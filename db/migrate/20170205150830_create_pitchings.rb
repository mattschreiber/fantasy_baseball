class CreatePitchings < ActiveRecord::Migration
  def change
    create_table :pitchings do |t|
      t.integer :year
      t.integer :wins
      t.integer :loss
      t.integer :games
      t.integer :gs
      t.float :innings
      t.integer :cg
      t.integer :shutouts
      t.integer :sv
      t.integer :hits
      t.integer :er
      t.integer :hr
      t.integer :bb
      t.integer :so
      t.float :ba_opp
      t.float :era
      t.float :whip
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
