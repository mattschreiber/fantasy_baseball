class AddInningsAndGpToTeamSeasons < ActiveRecord::Migration
  def change
  	add_column :team_seasons, :innings, :float
  	add_column :team_seasons, :gp, :integer
  end
end
