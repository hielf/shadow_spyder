class AddDownloadedVideoToSpyderVideo < ActiveRecord::Migration
  def change
    add_reference :downloaded_videos, :spyder_video, index: true, foreign_key: true
  end
end
