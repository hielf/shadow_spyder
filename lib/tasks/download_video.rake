namespace :download_video do
  task :download => :environment do
    videos = SpyderVideo.approved.limit(5)

    Parallel.map(videos, in_processes: 5) do |v|
      SpyderVideo.transaction do
        s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} '#{v.src}'") or false

        Rails.logger.warn "视频s1: #{v.translate_name} #{s1}" if s1 == false
        if s1
          filePath = Dir.glob("#{APP_CONFIG['path_to_root']}/tmp/d_video/#{v.id}.*").first
          s2 = system("ffmpegthumbnailer -i #{filePath} -o #{APP_CONFIG['path_to_root']}/tmp/d_video/thumb_#{v.id}.jpeg -s 640") or false
        end
        v.download if (s1 && s2)
      end
    end
  end
  
end
