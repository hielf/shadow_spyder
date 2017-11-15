class AddOpenIdToSpyders < ActiveRecord::Migration
  def change
    add_column :spyders, :open_id, :string
  end
end
