class CreateTeamSeasons < ActiveRecord::Migration
  def change
    create_table :team_seasons do |t|

    	t.integer :year
    	t.integer :place
    	
    	t.integer :run_points
    	t.integer :hr_points
    	t.integer :rbi_points
    	t.integer :sb_points
    	t.integer :avg_points
    	t.integer :win_points
    	t.integer :k_points
    	t.integer	:sv_points
    	t.integer :whip_points
    	t.integer	:era_points

    	t.integer	:total_run
    	t.integer	:total_hr
    	t.integer :total_rbi
    	t.integer	:total_sb
    	t.integer :total_avg
    	t.integer :total_win
    	t.integer :total_k
    	t.integer :total_sv
    	t.integer :total_whip
    	t.integer :total_era

    	t.references :owner, index: true, foreign_key: true
      t.timestamps null: false
    end
  end			
end
