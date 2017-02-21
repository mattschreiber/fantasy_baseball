class RemovePlayerAbbrFromOwner < ActiveRecord::Migration
  def change
    remove_column :owners, :player_abbr, :string
  end
end
