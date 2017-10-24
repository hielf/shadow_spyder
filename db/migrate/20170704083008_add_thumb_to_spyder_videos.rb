class AddThumbToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :qiniu_thumb_url, :string
  end
end
