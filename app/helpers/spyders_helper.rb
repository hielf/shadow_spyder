module SpydersHelper
  def get_categories
    url = APP_CONFIG['vod_root'] + "/api/v1/categories?per=100"
    res = HTTParty.get url
    data = JSON.parse(res.body)["data"]
    a = []
    data["categories"].each do |c|
      a << [c["id"], c["name"]]
    end
    return a
  end

  def get_keywords
    page = 1
    a = []
    loop do
      url = APP_CONFIG['vod_root'] + "/api/v1/columns?per=100&page=#{page}"
      res = HTTParty.get url
      data = JSON.parse(res.body)["data"]
      break if data["columns"].empty?
      data["columns"].each do |c|
        c["keyword"].split('|').each do |str|
          a << [c["id"], str] if !a.include? str
        end
      end
      page = page + 1
    end
    return a
  end

  def get_columns
    page = 1
    a = []
    loop do
      url = APP_CONFIG['vod_root'] + "/api/v1/columns?per=100&page=#{page}"
      res = HTTParty.get url
      data = JSON.parse(res.body)["data"]
      break if data["columns"].empty?
      data["columns"].each do |c|
        a << [c["id"], c["name"]]
      end
      page = page + 1
    end
    return a
  end

  def get_video_keys
    page = 1
    a = []
    url = APP_CONFIG['vod_root'] + "/api/v1/videos?per=50&page=#{page}"
    res = HTTParty.get url
    data = JSON.parse(res.body)["data"]
    data["videos"].each do |v|
      a << v["nickname"]
    end
    a.uniq!
    return a
  end

  def get_videos
    page = 1
    a = []
    url = APP_CONFIG['vod_root'] + "/api/v1/videos?per=50&page=#{page}"
    res = HTTParty.get url
    data = JSON.parse(res.body)["data"]
    data["videos"].each do |v|
      a << [v["id"], v["nickname"]]
    end
    a.uniq!
    return a
  end

  def modify_user_info(user, nick_name, avatar)
    url = APP_CONFIG['vod_root'] + "/api/v1/users/update_nickname"
    res = HTTParty.post(url,
            :body => { :nickname => nick_name}.to_json,
            :headers => { 'Content-Type' => 'application/json', 'token' => user.token } )
    code_1 = JSON.parse(res.body)["code"]
    sleep 0.1
    url = APP_CONFIG['vod_root'] + "/api/v1/users/update_avatar"
    res = HTTParty.post(url,
            :body => { :avatar => avatar}.to_json,
            :headers => { 'Content-Type' => 'application/json', 'token' => user.token } )
    code_2 = JSON.parse(res.body)["code"]
    return code_1 + code_2
  end

  def publish_comment(user, video_id, comment)
    url = APP_CONFIG['vod_root'] + "/api/v1/comments"
    res = HTTParty.post(url,
            :body => { :video_id => video_id,
                       :body => comment}.to_json,
            :headers => { 'Content-Type' => 'application/json', 'token' => user.token } )
    data = JSON.parse(res.body)
  end

  def get_youku_videos(key)
    root = 'http://www.soku.com'
    url = root +"/search_video/q_#{key}?orderby=2"
    url = URI.encode(url)
    begin
      response = Http::Exceptions.wrap_and_check do
        HTTParty.get url
      end
    rescue Http::Exceptions::HttpException => e
      p "网络连接异常"
      sleep 30
    end

    if response
      count = 0
      html = response.body
      doc = Nokogiri::HTML(html)

      if doc.css('.v').count > 1
        doc.css('.v').each_with_index do |item, index|
          break if count > 1
          begin
            # title = item.search('.v-meta-title a').attr('title').text
            author = item.search('.v-meta-data').search('.username').children[1].text
            views_count = item.search('.v-meta-data').search('.pub').text.gsub(/\D/,"").to_i
            href = item.search('.v-meta-title a').attr('href').value
            if href[0..1] == "//"
              href = "http:" + href
            end
          rescue Exception => exc
            # puts("异常 upload_time: " + time.to_s)
            next
          end
          if (author.include? key || views_count >= 500)
            count = count + 1
            get_youku_comments(href, key)
          end
        end
      end
    end
  end

  def get_youku_comments(href, key)
    user_id = User.find_by(nick_name: key) ? User.find_by(nick_name: key).id : nil
    if Rails.env == "production"
      # Rails.logger.warn  "env production mode start #{Time.now}"
      headless = Headless.new(display: 100, reuse: true, destroy_at_exit: false)
      headless.start
      # Rails.logger.warn  "headless started #{Time.now}"
    end
    browser = Watir::Browser.new :chrome #, headless: true
    # Rails.logger.warn  "browser started #{Time.now}"
    browser.goto(href)
    # browser.driver.execute_script("window.scrollBy(0,500)")
    browser.scroll.to :center
    # Rails.logger.warn  "browser goto #{href} #{Time.now}"
    # sleep 3
    browser.div(id: 'videoCommentlist').wait_until_present
    page = Nokogiri::HTML.parse(browser.html)
    page.css('.comment-content').each do |item|
      avatar = item.search('.comment-user-avatar a').first.children.attr('src').value
      nick_name = item.search('.comment-user-info a').text.tr("\n","")
      text = item.search('.comment-text p').text.tr("\n","")

      RawComment.transaction do
        next if !RawComment.find_by(url: href, text: text).nil?
        RawComment.create!(comment_user: nick_name,
                           avatar: avatar,
                           text: text,
                           key_word: key,
                           url: href,
                           user_id: user_id)
      end
    end
    browser.close
    headless.destroy if Rails.env == "production"

  end

end
