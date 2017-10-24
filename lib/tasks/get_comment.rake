namespace :publish do
  task :get_comment => :environment do
    include SpydersHelper
    include SessionsHelper

    # start get comments from youku
    a = get_video_keys
    # Rails.logger.warn "get comment start #{Time.now}"
    a.each do |key|
      # Rails.logger.warn  "key #{key} started #{Time.now}"
      get_youku_videos(key)
      # Rails.logger.warn  "key #{key} finished #{Time.now}"
      sleep 5
    end unless a.empty?
    # Rails.logger.warn "get comment end #{Time.now}"
  end
end
