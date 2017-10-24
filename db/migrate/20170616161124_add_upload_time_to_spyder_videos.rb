class AddUploadTimeToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :upload_time, :datetime
  end
end
