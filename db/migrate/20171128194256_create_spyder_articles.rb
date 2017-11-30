class CreateSpyderArticles < ActiveRecord::Migration
  def change
    create_table :spyder_articles do |t|
      t.integer :spyder_id
      t.string :title
      t.string :url
      t.string :author
      t.string :summary

      t.timestamps null: false
    end
    add_index :spyder_articles, :spyder_id
  end
end
