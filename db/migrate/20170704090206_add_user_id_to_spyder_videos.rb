class AddUserIdToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :user_id, :integer
    add_index :spyder_videos, :user_id
  end
end
