class AddIndexToCarCategories < ActiveRecord::Migration
  def change
    add_index :car_categories, [:state, :depth]
  end
end
