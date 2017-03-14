class AddWatchToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :watch, :boolean
  end
end
