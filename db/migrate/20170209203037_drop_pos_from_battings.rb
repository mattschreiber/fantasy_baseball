class DropPosFromBattings < ActiveRecord::Migration
  def change
  	remove_column :battings, :pos
  end
end
