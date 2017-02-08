class CreatePlayersMlbteams < ActiveRecord::Migration
  def change
    create_table :players_mlbteams do |t|
      t.references :mlbteam, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
    end
  end
end
