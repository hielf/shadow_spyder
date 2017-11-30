class Spyder < ActiveRecord::Base
  has_many :spyder_videos
  has_many :spyder_articles

  def get_scholar(href,key,spyder)
    # href = 'https://scholar.google.com/scholar?hl=zh-CN&as_sdt=0%2C5&q=临床&btnG='
    # href = URI.encode(href)
    root = 'https://scholar.google.com'
    begin
      response = Http::Exceptions.wrap_and_check do
        HTTParty.get href
      end
    rescue Http::Exceptions::HttpException => e
      p "网络连接异常"
      sleep 30
    end
    if response
      html = response.body
      doc = Nokogiri::HTML(html)
      if doc.css("div.gs_r.gs_or.gs_scl").count > 1
        doc.css("div.gs_r.gs_or.gs_scl").each do |item|
          # p item
          title = item.at_css("div h3").text
          url = item.at_css("div h3 a")['href'] if item.at_css("div h3 a")
          author = item.at_css("div.gs_a").text
          summary = item.at_css("div.gs_rs").text.gsub!("\n","") if item.at_css("div.gs_rs")
          begin
            SpyderArticle.create!(title: title, author: author, url: url, summary: summary, spyder_id: spyder.id)
            # puts("加入成功")
          rescue
            puts("数据有错误")
          end
        end
      end

      # if doc.css('div.gs_n').count>0
      #   doc.css('span.gs_ico_nav_page').each do |i|
      #   # puts(doc.css('.branded-page-box a').last.search('span').text.to_i)
      #   if doc.css('.branded-page-box a').last.search('span').text.to_i == 0
      #     next_page = doc.css('.branded-page-box a').last.attr('href') + "&hl=en-US"
      #     # puts next_page
      #     # puts("+++++++++++++++++++++++++ new page +++++++++++++++++++")
      #     if spyder.page < APP_CONFIG['spyder_page_count']
      #       get_youtube_video_info(root + next_page,key,spyder)
      #     end
      #   end
      # end

    end
  end

  def get_youtube_video_info(href,key,spyder)
    root = 'https://www.youtube.com'
    # key = "雷诺"
    # href = root +"/results?q=#{key}&sp=EgIIBUgA6gMA&hl=en-US"
    # href = URI.encode(href)
    return if key[0] == "^"

    begin
      response = Http::Exceptions.wrap_and_check do
        HTTParty.get href
      end
    rescue Http::Exceptions::HttpException => e
      p "网络连接异常"
      sleep 30
    end
    # response = RestClient.get(href)
    if response
      html = response.body
      doc = Nokogiri::HTML(html)
      if doc.css('.item-section>li').count > 1
        doc.css('.item-section>li').each do |item|
          begin
            href = item.search('.yt-lockup-title a').attr('href')
            title = Tradsim::to_sim(item.search('.yt-lockup-title a').text.to_s)
            views_count = item.search('.yt-lockup-meta-info').children[1].text.gsub!(/\D/,"")
            views_count = 0 if views_count.nil?
            # upload_time = item.search('.yt-lockup-meta-info').children[0].text.gsub!("個", "").gsub!("前", "")
            time = item.search('.yt-lockup-meta-info').children[0].text.gsub!(" ", ".")
            duration = item.search('.video-time').text
            # author = item.search('.g-hovercard').text
            author = item.search('.yt-lockup-byline').text
            keyword = key
            upload_time = eval(time)
          rescue Exception => exc
            # puts("异常 upload_time: " + time.to_s)
            next
          end
          next if (upload_time.nil? || views_count.nil?)
          next if ((author.downcase.include? "game") || (author.downcase.include? "gaming")|| (author.downcase.include? "天下有警"))
          check_1 = SpyderVideo.find_by(src: root + href).nil?
          check_2 = SpyderVideo.find_by(name: title, video_duration: duration).nil?
          check_3 = views_count.to_i > APP_CONFIG['spyder_min_views_count']
          check_4 = upload_time >= eval(APP_CONFIG['spyder_upload_time']) if upload_time.class == ActiveSupport::TimeWithZone

          if check_3 && check_4
            begin
              SpyderVideo.create!(src: root + href, name: title, author: author, pv: views_count, video_duration: duration, key_word: keyword, upload_time: upload_time, source_type: "youtube", spyder_id: spyder.id)
              # puts("加入成功")
            rescue
              puts("数据有错误")
            end
          else
            # puts("已存在这条数据") if (check_1 == false || check_2 == false)
            # puts("播放数不足") if check_3 == false
            # puts("上传日期过早") if check_4 == false
            next
          end
        end

        spyder.update!(page: spyder.page + 1)
        if doc.css('.branded-page-box a').count>0
          # puts(doc.css('.branded-page-box a').last.search('span').text.to_i)
          if doc.css('.branded-page-box a').last.search('span').text.to_i == 0
            next_page = doc.css('.branded-page-box a').last.attr('href') + "&hl=en-US"
            # puts next_page
            # puts("+++++++++++++++++++++++++ new page +++++++++++++++++++")
            if spyder.page < APP_CONFIG['spyder_page_count']
              get_youtube_video_info(root + next_page,key,spyder)
            end
          end
        end
      end
    end
  end

end
