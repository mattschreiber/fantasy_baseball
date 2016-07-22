class CreateCurrentSeasons < ActiveRecord::Migration
  def up
  	execute <<-SQL
    CREATE VIEW current_seasons AS
    	SELECT 
    	total_run / gp::float AS run_ratio,
    	total_hr / gp::float AS hr_ratio,
    	total_rbi / gp::float AS rbi_ratio,
    	total_sb / gp::float AS sb_ratio,
    	total_avg AS avg_ratio,
    	total_win / innings::float AS win_ratio,
    	total_k / innings::float AS k_ratio,
    	total_sv / innings::float AS sv_ratio,
			total_whip AS whip_ratio,
			total_era AS era_ratio,
			owner_id,
      updated_at
			FROM team_seasons
			WHERE current_season = true
			SQL
  end

  def down
  	execute <<-SQL
  	DROP VIEW current_seasons
  	SQL
  end
end
