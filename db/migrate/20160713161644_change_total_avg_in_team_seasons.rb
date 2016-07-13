class ChangeTotalAvgInTeamSeasons < ActiveRecord::Migration
  def change
  	change_column :team_seasons, :total_avg, :float
  end
end
