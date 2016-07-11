class DropTeamSeasons < ActiveRecord::Migration
  def change
  	drop_table(:team_seasons)
  end
end
