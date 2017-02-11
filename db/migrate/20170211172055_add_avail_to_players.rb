class AddAvailToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :avail, :boolean
  end
end
