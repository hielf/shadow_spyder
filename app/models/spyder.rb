class Spyder < ActiveRecord::Base

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
            # upload_time = item.search('.yt-lockup-meta-info').children[0].text.gsub!("個", "").gsub!("前", "")
            time = item.search('.yt-lockup-meta-info').children[0].text.gsub!(" ", ".")
            duration = item.search('.video-time').text
            author = item.search('.g-hovercard').text
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

          check_3 = true if keyword[0] == "!"

          if check_1 && check_2 && check_3 && check_4
            begin
              SpyderVideo.create!(src: root + href, name: title, author: author, pv: views_count, video_duration: duration, key_word: keyword, upload_time: upload_time, source_type: "youtube")
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

  def get_youku_video_info(href,key,spyder)
    root = 'http://www.soku.com/search_video/q_'
    # key = "*66车讯"
    # href = "http://www.soku.com/search_video/q_#{key}?orderby=2"
    # href = URI.encode(href)
    return if key[0] != "*"

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

      if doc.css('.v').count > 1
        doc.css('.v').each do |item|
          begin
            title = item.search('.v-meta-title a').attr('title').text
            href = item.search('.v-meta-title a').attr('href').value
            if href[0..1] == "//"
              href = "http:" + href
            end
            views_count = item.search('.v-meta-data').search('.pub').text.gsub(/\D/,"").to_i
            author = item.search('.v-meta-data').search('.username').children[1].text
            time = item.search('.v-meta-data').search('.r').text.gsub("分钟", ".minutes").gsub("小时", ".hours").gsub("天", ".days").gsub("月", ".months").gsub("年", ".years").gsub("前", ".ago")
            duration = item.search('.v-thumb-tagrb span').search('.v-time').text
            keyword = key
            upload_time = eval(time)
          rescue Exception => exc
            # puts("异常 upload_time: " + time.to_s)
            next
          end
          next if (upload_time.nil? || views_count.nil?)
          check_1 = SpyderVideo.find_by(src: href).nil?
          check_2 = SpyderVideo.find_by(name: title, video_duration: duration).nil?
          check_3 = views_count.to_i > APP_CONFIG['spyder_min_views_count']
          check_4 = upload_time >= eval(APP_CONFIG['spyder_upload_time']) if upload_time.class == ActiveSupport::TimeWithZone

          check_3 = true if keyword[0] == "!"
          check_3 = true if keyword[0] == "*"

          if check_1 && check_2 && check_3 && check_4
            begin
              SpyderVideo.create!(src: href, name: title, author: author, pv: views_count, video_duration: duration, key_word: keyword, upload_time: upload_time, source_type: "youku")
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

        if doc.css('.sk_pager a').count > 0
          if doc.css('.sk_pager a').last.search('span').text.to_i == 0
            next_page = doc.css('.sk_pager a').last.attr('href').gsub("/search_video/q_", "") + "?orderby=2"
            if spyder.page < APP_CONFIG['spyder_page_count']
              get_youku_video_info(root + next_page,key,spyder)
            end
          end
        end
      end
    end
  end

end
