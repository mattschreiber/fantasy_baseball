class CreatePlayersPositions < ActiveRecord::Migration
  def change
    create_table :players_positions do |t|
      t.references :position, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
    end
  end
end
