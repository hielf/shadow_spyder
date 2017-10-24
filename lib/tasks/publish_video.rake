namespace :download_video do
  task :publish => :environment do
    include SpyderVideosHelper

    videos = SpyderVideo.downloaded.limit(5)

    Parallel.map(videos, in_processes: 5) do |video|
      if qiniu_upload(video)
        sleep 180
        if publish_video(video)
          s1 = system("rm -rf #{APP_CONFIG['path_to_root']}/tmp/d_video/#{video.id}.*") or false
          s2 = system("rm -rf #{APP_CONFIG['path_to_root']}/tmp/d_video/thumb_#{video.id}.jpeg") or false
          video.publish if (s1 && s2)
        end
      end
    end
  end
end
