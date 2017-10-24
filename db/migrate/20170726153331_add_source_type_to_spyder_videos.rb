class AddSourceTypeToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :source_type, :string
  end
end
