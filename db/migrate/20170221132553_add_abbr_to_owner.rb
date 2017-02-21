class AddAbbrToOwner < ActiveRecord::Migration
  def change
    add_column :owners, :abbr, :string
  end
end
