class AddCategoryStrToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :category_str, :string
  end
end
