class TeamSeason < ActiveRecord::Base
	belongs_to :owner

	default_scope {order year: :desc}


	CATEGORIES = ["total_run", "total_hr", "total_rbi", "total_sb", "total_avg", "total_win", "total_k", "total_sv", "total_era", "total_whip"]



	def self.rank
		TeamSeason.find_by_sql([
		"WITH ranks AS (
    SELECT total_run, total_hr, total_rbi, total_sb, total_avg, 
    			total_win, total_k, total_sv, total_era, total_whip, owner_id,

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


           count(*) OVER ()                     AS cnt
      FROM team_seasons
      WHERE year = 2015
    WINDOW run AS (ORDER BY total_run ASC),
    			 h AS (ORDER BY total_hr ASC),
           r AS (ORDER BY total_rbi ASC),
           sb AS (ORDER BY total_sb ASC),
           avg AS (ORDER BY total_avg ASC)
		)
		SELECT total_run, total_hr, total_rbi, total_sb, total_avg, owner_id,
					 (avg(run_rn) OVER run)::float                   AS run_pts,
		       (avg(hr_rn) OVER h)::float                      AS hr_pts,
		       (avg(rbi_rn) OVER r)::float                     AS rbi_pts,
		       (avg(sb_rn) OVER sb)::float                     AS sb_pts,
		       (avg(avg_rn) OVER avg)::float                   AS avg_pts,
		       (avg(hr_rn) OVER h + avg(rbi_rn) OVER r + avg(sb_rn) OVER sb + avg(run_rn) OVER run + avg(avg_rn) OVER avg)::float AS ttl_pts
		  FROM ranks
		WINDOW run AS (PARTITION BY run_aprx),
					 h AS (PARTITION BY hr_aprx),
		       r AS (PARTITION BY rbi_aprx),
		       sb AS (PARTITION BY sb_aprx),
		       avg AS (PARTITION BY avg_aprx)
		 ORDER BY ttl_pts ASC"])

	end


	# def self.calc_season_points (year)
	# 	# accepts year as parameter and returns owner name and total points for season
	# 	# but doesn't calculate half points correctly, holding onto for now  in case
	# 	# parts are useful in the future
		
	# 	standings = {}

	# 	CATEGORIES.each do |cat|
	# 		hash = {}
	# 		sorted_hash = {}
	# 		h = {}

	# 		if cat == "total_era" || cat == "total_whip"
	# 			hash = TeamSeason.where("year = ?", year).pluck(:owner_id, cat).to_h
	# 			sorted_hash = hash.sort_by{|owner, run| run}.to_h
	# 			sorted_hash.keys.map do |k| 
	# 				h["#{k}"] = sorted_hash.keys.reverse.index(k) + 1
	# 			end
	# 		else
	# 			hash = TeamSeason.where("year = ?", year).pluck(:owner_id, cat).to_h
	# 			sorted_hash = hash.sort_by{|owner, val| val}.to_h
	# 			sorted_hash.keys.map do |k| 
	# 				h["#{k}"] = sorted_hash.keys.index(k) + 1.to_f
	# 			end
	# 		end
	# 		standings.merge!(h){|key, oldval, newval| oldval + newval}
	# 	end	
	# 	standings = standings.map{|k, v| [Owner.find(k).name, v]}.to_h	
	# 	return standings
	# end


	def self.recursive (n, array)
		if n < 0 || n > array.length
			puts 1
		else
			if array[n] == array[n+1]
				recursive(n+1, array)
			else
				pp n+1
			end
		end
	end

	

end

# hr.merge(run){|key, oldval, newval| oldval + newval}
# array.map{|e| array.index(e) + 1}
# list << TeamSeason.recursive(n, array)

# points = 10
# sorted_hash.keys.each do |k|
# 	h["#{k}"]= points
# points = points - 1
# end
# assign index value as point to hash with k = owner_id
