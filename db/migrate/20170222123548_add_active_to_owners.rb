class AddActiveToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :active, :boolean
  end
end
