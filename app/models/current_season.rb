class CurrentSeason < ActiveRecord::Base
	belongs_to :owner

	def self.ratio_standings

		CurrentSeason.find_by_sql([
			"WITH ranks AS (
	    SELECT run_ratio, hr_ratio, rbi_ratio, sb_ratio, avg_ratio, 
	    			win_ratio, k_ratio, sv_ratio, era_ratio, whip_ratio, owner_id, current_seasons.updated_at,
	    			concat_ws(' ', owners.first_name, owners.last_name) AS name,

	  			rank() OVER run                        AS run_rank,
	        row_number() OVER run                  AS run_rn,
	        count(*) OVER () - rank() OVER run  + 1 AS run_aprx,

		       rank() OVER h                        AS hr_rank,
		       row_number() OVER h                  AS hr_rn,
		       count(*) OVER () - rank() OVER h + 1 AS hr_aprx,

		       rank() OVER r                        AS rbi_rank,
		       row_number() OVER r                  AS rbi_rn,
		       count(*) OVER () - rank() OVER r + 1 AS rbi_aprx,

		       rank() OVER sb                        AS sb_rank,
		       row_number() OVER sb                  AS sb_rn,
		       count(*) OVER () - rank() OVER sb + 1 AS sb_aprx,

		       rank() OVER avg                        AS avg_rank,
		       row_number() OVER avg                  AS avg_rn,
		       count(*) OVER () - rank() OVER avg + 1 AS avg_aprx,

	        rank() OVER w                        AS win_rank,
	        row_number() OVER w                  AS win_rn,
	        count(*) OVER () - rank() OVER w  + 1 AS win_aprx,

	        rank() OVER k 											AS k_rank,
	        row_number() OVER k 								AS k_rn,
	        count(*) OVER () - rank() OVER k  + 1 AS k_aprx,

	        rank() OVER sv 											AS sv_rank,
	        row_number() OVER sv 								AS sv_rn,
	        count(*) OVER () - rank() OVER sv  + 1 AS sv_aprx,

	        rank() OVER era 											AS era_rank,
	        row_number() OVER era 								AS era_rn,
	        count(*) OVER () - rank() OVER era  + 1 AS era_aprx,

	        rank() OVER whip 											AS whip_rank,
	        row_number() OVER whip 								AS whip_rn,
	        count(*) OVER () - rank() OVER whip  + 1 AS whip_aprx,


	           count(*) OVER ()                     AS cnt
	      FROM current_seasons INNER JOIN owners ON current_seasons.owner_id = owners.id
	    WINDOW run AS (ORDER BY run_ratio ASC),
	    			 h AS (ORDER BY hr_ratio ASC),
	           r AS (ORDER BY rbi_ratio ASC),
	           sb AS (ORDER BY sb_ratio ASC),
	           avg AS (ORDER BY avg_ratio ASC),
	           w as (ORDER BY win_ratio ASC),
	           k as (ORDER BY k_ratio ASC),
	           sv as (ORDER BY sv_ratio ASC),
	           era as (ORDER BY era_ratio DESC),
	           whip as (ORDER BY whip_ratio DESC)
			)
			SELECT run_ratio, hr_ratio, rbi_ratio, sb_ratio, avg_ratio, win_ratio, k_ratio, sv_ratio, era_ratio, whip_ratio, owner_id, updated_at, name,
						 (avg(run_rn) OVER run)::float                   AS run_pts,
			       (avg(hr_rn) OVER h)::float                      AS hr_pts,
			       (avg(rbi_rn) OVER r)::float                     AS rbi_pts,
			       (avg(sb_rn) OVER sb)::float                     AS sb_pts,
			       (avg(avg_rn) OVER avg)::float                   AS avg_pts,
			       (avg(win_rn) OVER w)::float										 AS win_pts,
			       (avg(k_rn) OVER k)::float											 AS k_pts,
			       (avg(sv_rn) OVER sv)::float										 AS sv_pts,
			       (avg(era_rn) OVER era)::float									 AS era_pts,
			       (avg(whip_rn) OVER whip)::float								 AS whip_pts,
			       (avg(hr_rn) OVER h + avg(rbi_rn) OVER r + avg(sb_rn) OVER sb + avg(run_rn) OVER run + avg(avg_rn) OVER avg + avg(win_rn) OVER w + avg(k_rn) OVER k + avg(sv_rn) OVER sv + avg(era_rn) OVER era + avg(whip_rn) OVER whip)::float AS ttl_pts
			  FROM ranks 
			WINDOW run AS (PARTITION BY run_aprx),
						 w AS (PARTITION BY win_aprx),
						 h AS (PARTITION BY hr_aprx),
			       r AS (PARTITION BY rbi_aprx),
			       sb AS (PARTITION BY sb_aprx),
			       avg AS (PARTITION BY avg_aprx),
			       k AS (PARTITION BY k_aprx),
			       sv AS (PARTITION BY sv_aprx),
			       era AS (PARTITION BY era_aprx),
			       whip AS (PARTITION BY whip_aprx)
			 ORDER BY ttl_pts DESC"])

	end
end
