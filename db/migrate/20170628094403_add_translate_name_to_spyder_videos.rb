class AddTranslateNameToSpyderVideos < ActiveRecord::Migration
  def change
    add_column :spyder_videos, :translate_name, :string
  end
end
