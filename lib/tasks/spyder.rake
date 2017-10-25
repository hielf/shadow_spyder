namespace :get_data do
  task :spyder => :environment do
    include SpydersHelper

    #clean
    p "start at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
    # Spyder.where("active = ? AND end_time <= ?", false, 48.hours.ago).destroy_all
    begin
      connection = ActiveRecord::Base.connection
      sql = "delete from spyders where active = false AND end_time <= '#{24.hours.ago}'"
      connection.execute(sql)
    end
    videos = SpyderVideo.unapproved.where("created_at <= ?", eval(APP_CONFIG['spyder_upload_time']))
    videos.destroy_all
    p "finish clean at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"

    if Spyder.where(active: true).count > 0
      #recycle
      Spyder.where(active: true).each do |s|
        s.update!(end_time: Time.now, active: false) if s.begin_time < 1.hour.ago
      end
    else
      p Time.now.strftime("%Y-%m-%d %H:%M:%S")
      root = 'https://www.youtube.com'
      # a = []
      # key_word_list = CarCategory.available_depth_3
      # key_word_list.each do |row|
      #   row.keyword.split('|').each do |str|
      #     a << str if !a.include? str
      #   end
      # end
      a = get_keywords
      a.map! {|k| k[1]}
      p "keyword get at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"

      Parallel.map(a.shuffle, in_processes: 4) do |key|
        ActiveRecord::Base.connection_pool.with_connection do
          spyder = Spyder.create!(site: root, begin_time: Time.now)
          url = root +"/results?q=#{key}&sp=EgIIBUgA6gMA&hl=en-US"
          url = URI.encode(url)
          spyder.update!(keyword: key)
          spyder.get_youtube_video_info(url,key,spyder)
          spyder.update!(end_time: Time.now, active: false)
        end
      end

      p "ytb at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      ########################## www.soku.com ##########################
      root = 'http://www.soku.com'

      Parallel.map(a.shuffle, in_processes: 2) do |key|
        ActiveRecord::Base.connection_pool.with_connection do
          spyder = Spyder.create!(site: root, begin_time: Time.now)
          url = root +"/search_video/q_#{key}?orderby=2"
          url = URI.encode(url)
          spyder.update!(keyword: key)
          spyder.get_youku_video_info(url,key,spyder)
          spyder.update!(end_time: Time.now, active: false)
        end
      end

      p "yk at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      # Spyder.connection.reconnect!
      Spyder.where(active: true).each do |s|
        s.update!(end_time: Time.now, active: false)
      end
      p Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
