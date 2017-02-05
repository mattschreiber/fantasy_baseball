class CreateBattings < ActiveRecord::Migration
  def change
    create_table :battings do |t|
      t.integer :year
      t.integer :games
      t.integer :ab
      t.integer :runs
      t.integer :hits
      t.integer :double
      t.integer :triple
      t.integer :hr
      t.integer :rbi
      t.integer :sb
      t.integer :cs
      t.integer :bb
      t.integer :so
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
