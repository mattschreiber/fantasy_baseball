class CreateMlbteams < ActiveRecord::Migration
  def change
    create_table :mlbteams do |t|
      t.string :abbr
      t.string :name

      t.timestamps null: false
    end
  end
end
