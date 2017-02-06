class TeamSeason < ActiveRecord::Base
	belongs_to :owner

	default_scope {order year: :desc}


	CATEGORIES = ["total_run", "total_hr", "total_rbi", "total_sb", "total_avg", "total_win", "total_k", "total_sv", "total_era", "total_whip"]


	def self.import (file, current)
		#if the stats are for the current season, then existing current stats should be destroyed
		if !current.nil?
			TeamSeason.where(current_season: true).destroy_all
		end
			CSV.foreach(file.path, headers: true) do |row|
			parameters = ActionController::Parameters.new(row.to_hash)
			TeamSeason.create!(parameters.permit(
				:place, :year, :total_points,
				:run_points, :hr_points, :rbi_points, :sb_points, :avg_points, 
				:win_points, :k_points, :sv_points, :whip_points, :era_points, 
				:total_run, :total_hr, :total_rbi, :total_sb, :total_avg, 
				:total_win, :total_k, :total_era, :total_whip, :total_sv, 
				:owner_id, :gp, :innings, 
				:created_at, :updated_at, :current_season))
		end

	end

	#hash parameters (:year)
	def self.rank year
		TeamSeason.find_by_sql([
		"WITH ranks AS (
    SELECT total_run, total_hr, total_rbi, total_sb, total_avg, 
    			total_win, total_k, total_sv, total_era, total_whip, owner_id,
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
      FROM team_seasons INNER JOIN owners ON team_seasons.owner_id = owners.id
      WHERE year = :year and current_season = false
    WINDOW run AS (ORDER BY total_run ASC),
    			 h AS (ORDER BY total_hr ASC),
           r AS (ORDER BY total_rbi ASC),
           sb AS (ORDER BY total_sb ASC),
           avg AS (ORDER BY total_avg ASC),
           w as (ORDER BY total_win ASC),
           k as (ORDER BY total_k ASC),
           sv as (ORDER BY total_sv ASC),
           era as (ORDER BY total_era DESC),
           whip as (ORDER BY total_whip DESC)
		)
		SELECT total_run, total_hr, total_rbi, total_sb, total_avg, total_win, total_k, total_sv, total_era, total_whip, owner_id, name,
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
		 ORDER BY ttl_pts DESC", year: year])

	end


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




# rank method using ruby instead of postgres window functions
# postgres is more efficient algorithm, but this should work independent of db
def self.rankv2(year, cat)
	list = []
	if cat == "total_era" || cat == "total_whip"
		hash = TeamSeason.where("year = ? and current_season = ?", year, false).order("#{cat}": :asc).pluck(:owner_id, cat).to_h
	else
		hash = TeamSeason.where("year = ? and current_season = ?", year, false).order("#{cat}": :desc).pluck(:owner_id, cat).to_h
	end

	hash.values.map {|k| list << k }

	i = 0
		points = 10
		# list = [5,5,5,2,1]
		p = []
		while i < list.length
			if list.rindex(list[i]) - list.index(list[i]) == 0 
				p[i] = points.to_f
				points = points - 1.0
				i = i +1
			elsif list.rindex(list[i]) - list.index(list[i]) == 1
				p[i] = points - 0.5
				p[i+1] = points - 0.5
				points = points - 2
				i = i + 2
			elsif list.rindex(list[i]) - list.index(list[i]) == 2
				p[i] = points - 1.0
				p[i+1] = points - 1.0
				p[i+2] = points - 1.0
				points = points - 3
				i = i + 3
			elsif list.rindex(list[i]) - list.index(list[i]) == 3
				p[i] = points - 1.5
				p[i+1] = points - 1.5
				p[i+2] = points - 1.5
				p[i+3] = points - 1.5
				points = points - 4
				i = i + 4
			elsif list.rindex(list[i]) - list.index(list[i]) == 4
				p[i] = points - 2.0
				p[i+1] = points - 2.0
				p[i+2] = points - 2.0
				p[i+4] = points - 2.0
				points = points - 5
				i = i + 5
			elsif list.rindex(list[i]) - list.index(list[i]) == 5
				p[i] = points - 2.5
				p[i+1] = points - 2.5
				p[i+2] = points - 2.5
				p[i+3] = points - 2.5
				p[i+4] = points - 2.5
				p[i+5] = points - 2.5
				points = points - 6
				i = i + 6	
			elsif list.rindex(list[i]) - list.index(list[i]) == 6
				p[i] = points - 3.0
				p[i+1] = points - 3.0
				p[i+2] = points - 3.0
				p[i+3] = points - 3.0
				p[i+4] = points - 3.0
				p[i+5] = points - 3.0
				p[i+6] = points - 3.0
				points = points - 7
				i = i + 7
			elsif list.rindex(list[i]) - list.index(list[i]) == 7
				p[i] = points - 3.5
				p[i+1] = points - 3.5
				p[i+2] = points - 3.5
				p[i+3] = points - 3.5
				p[i+4] = points - 3.5
				p[i+5] = points - 3.5
				p[i+6] = points - 3.5
				p[i+7] = points - 3.5
				points = points - 8
				i = i + 8	
			elsif list.rindex(list[i]) - list.index(list[i]) == 8
				p[i] = points - 4.0
				p[i+1] = points - 4.0
				p[i+2] = points - 4.0
				p[i+3] = points - 4.0
				p[i+4] = points - 4.0
				p[i+5] = points - 4.0
				p[i+6] = points - 4.0
				p[i+7] = points - 4.0
				p[i+8] = points - 4.0
				points = points - 9
				i = i + 9
			elsif list.rindex(list[i]) - list.index(list[i]) == 9
				p[i] = points - 4.5
				p[i+1] = points - 4.5
				p[i+2] = points - 4.5
				p[i+3] = points - 4.5
				p[i+4] = points - 4.5
				p[i+5] = points - 4.5
				p[i+6] = points - 4.5
				p[i+7] = points - 4.5
				p[i+8] = points - 4.5
				p[i+9] = points - 4.5
				points = points - 10
				i = i + 10
			end
		end

		counter = 0
		h = {}
		hash.keys.map do |k|
			h[k] = p[counter]
			counter = counter + 1
		end
		return h
	end
	

end


# calculates total points for all categories
# standings = {}
# h = {}
# CATEGORIES.each do |c|	
# 	h = TeamSeason.rankv2(2016, c)
# 	standings.merge!(h){|key, oldval, newval| oldval + newval}
# end



# hr.merge(run){|key, oldval, newval| oldval + newval}
# array.map{|e| array.index(e) + 1}
# list << TeamSeason.recursive(n, array)

# points = 10
# sorted_hash.keys.each do |k|
# 	h["#{k}"]= points
# points = points - 1
# end
# assign index value as point to hash with k = owner_id
