class AddPageToSpyders < ActiveRecord::Migration
  def change
    add_column :spyders, :page, :integer, default: 0
  end
end
