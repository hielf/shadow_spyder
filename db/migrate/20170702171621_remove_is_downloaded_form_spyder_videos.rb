class RemoveIsDownloadedFormSpyderVideos < ActiveRecord::Migration
  def change
    remove_column :spyder_videos, :is_downloaded
  end
end
