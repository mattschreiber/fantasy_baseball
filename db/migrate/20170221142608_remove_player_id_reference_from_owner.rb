class RemovePlayerIdReferenceFromOwner < ActiveRecord::Migration
  def change
    remove_column :owners, :player_id
  end
end
