class AddMlbteamToPitchings < ActiveRecord::Migration
  def change
    add_reference :pitchings, :mlbteam, index: true, foreign_key: true
  end
end
