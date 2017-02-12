class AddBatterToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :batter, :boolean
  end
end
