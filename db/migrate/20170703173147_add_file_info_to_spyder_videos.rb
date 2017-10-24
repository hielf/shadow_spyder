class AddFileInfoToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :file_name, :string
    add_column :spyder_videos, :file_type, :string
    add_column :spyder_videos, :file_hash, :string
    add_column :spyder_videos, :qiniu_url, :string
  end
end
