class AddTotalPointsToTeamSeasons < ActiveRecord::Migration
  def change
  	add_column :team_seasons, :total_points, :integer
  end
end
