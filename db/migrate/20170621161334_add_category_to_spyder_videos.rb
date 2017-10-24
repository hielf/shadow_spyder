class AddCategoryToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :category, :string

    add_index :spyder_videos, :src#, :unique => true
    add_index :spyder_videos, [:name, :video_duration]#, :unique => true
  end
end
