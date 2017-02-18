class CreatePlayerRankings < ActiveRecord::Migration
  def change
    create_table :player_rankings do |t|
      t.integer :my_rank
      t.integer :espn
      t.integer :cbs
      t.integer :mlb
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
