class DropPlayersMlbteams < ActiveRecord::Migration
  def change
  	drop_table(:players_mlbteams)
  end
end
