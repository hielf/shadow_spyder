class AddTranslateNameToCarCategories < ActiveRecord::Migration
  def change
    add_column :car_categories, :translate_name, :string
  end
end
