class AddIndexToSpyderVideos < ActiveRecord::Migration
  def change
    add_index :spyder_videos, :state
  end
end
