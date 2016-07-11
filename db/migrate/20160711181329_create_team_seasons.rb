class CreateTeamSeasons < ActiveRecord::Migration
  def change
    create_table :team_seasons do |t|
    	t.integer :year
    	t.integer :place
    	
    	t.float :run_points
    	t.float :hr_points
    	t.float :rbi_points
    	t.float :sb_points
    	t.float :avg_points
    	t.float :win_points
    	t.float :k_points
    	t.float	:sv_points
    	t.float :whip_points
    	t.float	:era_points

    	t.integer	:total_run
    	t.integer	:total_hr
    	t.integer :total_rbi
    	t.integer	:total_sb
    	t.integer :total_avg
    	t.integer :total_win
    	t.integer :total_k
    	t.integer :total_sv
    	t.float :total_whip
    	t.float :total_era
    	t.float :total_points

    	t.references :owner, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
