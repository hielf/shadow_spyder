namespace :download_video do
  task :download => :environment do
    videos = SpyderVideo.approved.limit(5)

    # srcs = videos.map do |v|
    #   v.src
    # end

    Parallel.map(videos, in_processes: 5) do |v|
      # res = system("youtube-dl -o 'tmp/d_video/%(title)s-%(id)s.%(ext)s' #{v}")
      # Rails.logger.warn "视频: #{v.translate_name} 开始下载"
      # s1 = system("youtube-dl -o '#{APP_CONFIG['path_to_root']}/tmp/d_video/#{v.id}.%(ext)s' #{v.src} &> /dev/null") or false
      SpyderVideo.transaction do
        if v.source_type == "youtube"
          # s1 = YoutubeDL.download v.src, output: "./tmp/d_video/#{v.id}.mp4"
          s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} '#{v.src}'") or false
        elsif v.source_type == "youku"
          # s1 = false
          # ['hd3', 'hd2'].each do |tag|
          #   s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} --format=#{tag} '#{v.src}'") or false
          #   break if s1
          # end
          info = `you-get -i '#{v.src}'`
          if info.include? "hd3"
            s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} --format=hd3 '#{v.src}'") or false
          elsif info.include? "hd2"
            s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} --format=hd2 '#{v.src}'") or false
          elsif info.include? "flvhd"
            s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} --format=flvhd '#{v.src}'") or false
          else
            s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} --format=mp4 '#{v.src}'") or false
          end
        end

        Rails.logger.warn "视频s1: #{v.translate_name} #{s1}" if s1 == false
        # Rails.logger.warn "youtube-dl -o './tmp/d_video/#{v.id}.%(ext)s' #{v.src} &> /dev/null"
        # Rails.logger.warn "#{system("youtube-dl -o './tmp/d_video/#{v.id}.%(ext)s' #{v.src}")}"
        # p s1
        if s1
          filePath = Dir.glob("#{APP_CONFIG['path_to_root']}/tmp/d_video/#{v.id}.*").first
          s2 = system("ffmpegthumbnailer -i #{filePath} -o #{APP_CONFIG['path_to_root']}/tmp/d_video/thumb_#{v.id}.jpeg -s 640") or false
        end
        # Rails.logger.warn "视频s2: ffmpegthumbnailer -i #{filePath} -o #{APP_CONFIG['path_to_root']}/tmp/d_video/thumb_#{v.id}.jpeg -s 640"
        # Rails.logger.warn "视频s2: #{v.translate_name} #{s2}"
        # p s2
        # p v.name + " finished"
        v.download if (s1 && s2)
        # Rails.logger.warn "视频: #{v.translate_name} 结束下载"
      end
    end
  end
end
