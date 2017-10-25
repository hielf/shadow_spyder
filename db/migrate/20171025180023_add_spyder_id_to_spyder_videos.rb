class AddSpyderIdToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :spyder_id, :integer

    add_index :spyder_videos, :spyder_id
  end
end
