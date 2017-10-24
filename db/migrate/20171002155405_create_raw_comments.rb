class CreateRawComments < ActiveRecord::Migration
  def change
    create_table :raw_comments do |t|
      t.string :comment_user
      t.string :avatar
      t.string :text
      t.string :key_word
      t.integer :user_id
      t.string :url
      t.string :state

      t.timestamps null: false
    end
    add_index :raw_comments, :user_id
  end
end
