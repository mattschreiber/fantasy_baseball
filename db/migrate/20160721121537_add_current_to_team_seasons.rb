class AddCurrentToTeamSeasons < ActiveRecord::Migration
  def change
  	add_column :team_seasons, :current_season, :boolean
  end
end
