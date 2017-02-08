class AddMlbteamToBattings < ActiveRecord::Migration
  def change
    add_reference :battings, :mlbteam, index: true, foreign_key: true
  end
end
