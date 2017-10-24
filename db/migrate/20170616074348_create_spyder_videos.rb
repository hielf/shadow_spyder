class CreateSpyderVideos < ActiveRecord::Migration
  def change
    create_table :spyder_videos do |t|
      t.string :src
      t.string :name
      t.string :author
      t.string :pv
      t.string :video_duration
      t.string :key_word
      t.string :state
      t.boolean :is_downloaded, default: false

      t.timestamps null: false
    end
  end
end
