class AddPlayerIdAndPlayerAbbrToOwner < ActiveRecord::Migration
  def change
    add_column :owners, :player_abbr, :string
    add_reference :owners, :player, index: true, foreign_key: true
  end
end
