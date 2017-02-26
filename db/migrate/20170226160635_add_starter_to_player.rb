class AddStarterToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :starter, :boolean
  end
end
