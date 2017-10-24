class CreateSpyders < ActiveRecord::Migration
  def change
    create_table :spyders do |t|
      t.string :site
      t.string :keyword
      t.datetime :begin_time
      t.datetime :end_time
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
