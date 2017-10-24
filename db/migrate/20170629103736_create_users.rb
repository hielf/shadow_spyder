class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile
      t.string :token

      t.timestamps null: false
    end
    add_index :users, :mobile, :unique => true
  end
end
