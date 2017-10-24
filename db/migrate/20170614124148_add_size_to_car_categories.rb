class AddSizeToCarCategories < ActiveRecord::Migration
  def change
    add_column :car_categories, :sizetype, :string
    add_column :car_categories, :fullname, :string
    add_column :car_categories, :keyword, :string
    add_column :car_categories, :state, :string
  end
end
