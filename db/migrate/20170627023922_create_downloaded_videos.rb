class CreateDownloadedVideos < ActiveRecord::Migration
  def change
    create_table :downloaded_videos do |t|
      t.string :url
      t.integer :state, null: false, default: 0
      t.string :video_format
      t.timestamps null: false
    end
  end
end
