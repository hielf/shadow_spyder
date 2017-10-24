# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# !!!!!!!!!
# ADD PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin to crontab -e

every 5.days do
  rake "get_data:car_category"
end

every 1.hour do
  rake "get_data:spyder"
end

every 30.minutes do
  rake "get_data:fit_category"
  # command "cd /var/www/shadowSpyder/current && RAILS_ENV=production bundle exec rake publish:get_comment --silent"
  # command "/var/www/shadowSpyder/current/lib/get_comment.sh"
end

every 13.minutes do
  rake "publish:get_comment"
  rake "publish:video_view"
end

every 10.minutes do
  rake "download_video:approve"
  rake "publish:publish_comment"
end

every 5.minutes do
  rake "download_video:publish"
  # command "ruby /var/www/shadowSpyder/current/lib/tasks/test.rb"
  # rake "publish:test"
  # command "/var/www/shadowSpyder/current/lib/get_comment.sh"
end

every 3.minutes do
  rake "download_video:download"
end
