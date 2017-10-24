namespace :publish do
  task :video_view => :environment do
    include SpydersHelper
    include SessionsHelper

    a = get_videos

    5.times do
      times = 1
      # 30 times, 3 videos each, 90 views in 1.5 min
      Parallel.map((a.first[0] - 30)..a.first[0], in_processes: 3) do |id|
        # raise Parallel::Break if times > 30
        dice = rand(0..9)
        next if dice > 2
        url = APP_CONFIG['vod_root'] + "/api/v1/videos/#{id}"
        res = HTTParty.get url
        p "---#{id}:#{res.code}------#{Time.now}-------times: #{times}"
        times = times + 1
        sleep 3
      end
    end

    times = 1
    # 20 times, 3 videos each, 60 views in 1 min
    Parallel.map((a.first[0] - 300)..a.first[0], in_processes: 3) do |id|
      # raise Parallel::Break if times > 20
      dice = rand(0..9)
      next if dice > 2
      url = APP_CONFIG['vod_root'] + "/api/v1/videos/#{id}"
      res = HTTParty.get url
      p "---#{id}:#{res.code}------#{Time.now}-------times: #{times}"
      times = times + 1
      sleep 3
    end

  end
end
