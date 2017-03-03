class AddSortToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :sort, :integer
  end
end
