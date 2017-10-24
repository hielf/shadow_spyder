class CreateCarCategories < ActiveRecord::Migration
  def change
    create_table :car_categories do |t|
      t.string :name
      t.string :initial
      t.string :logo
      t.string :parent_id
      t.string :depth

      t.timestamps null: false
    end
  end
end
