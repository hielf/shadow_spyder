class DownloadedVideo < ActiveRecord::Base
  belongs_to :spyder_video

  enum state: { undownload: 0, downloaded: 1, failed: 2 }
end
