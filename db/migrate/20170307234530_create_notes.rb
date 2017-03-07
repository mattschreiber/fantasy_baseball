class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note
      t.references :player, index: true, foreign_key: true
      t.references :owner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
