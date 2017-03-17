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
# hash should be key/value pairs of owner_id and sum for given category
def self.rankv2(hash)
	list = []
	points = hash.length #calculates the starting total points (i.e. 10 team league each category has a max of 10 points)
	hash.values.map {|k| list << k }
	i = 0
	value = 0
		p = []
		while i < list.length
			value = list.rindex(list[i]) - list.index(list[i])
			count = 0
			if value == 0
				p[i] = points.to_f
				points -= 1.0
				i += 1
			else
				while count <= value
					p[i] = points - (value / 2.to_f)
					i += 1
					count += 1
				end
				points -= value +  1
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

# calculates team points total based on player statistics for given year
	def self.project_team_standings
		# points = 10 #number of possible points for each category.  This needs to change if number of teams in league changes
		bat_hash = {}
		standings = {}
		team_cat_points = {}

		o = Owner.where(active: true).order(:id).pluck(:id)

		# This creates array that contains each teams team_totals by category (which is a hash) (team_totals method is from team_projection concern)
		arr = []
		bat_arr = []
		pitch_arr = []
		Owner.where(active: true).order(:id).each do |o|
		  bat_arr <<  Batting.team_totals(2017, o.id, true)
			pitch_arr << Pitching.team_totals(2017, o.id, false)
		end

		########################################################
		# merge bat_arr and pitch_arr
		i = 0
		bat_arr.each do |a|
			arr << a.merge(pitch_arr[i])
		end
		#######################################################

		# iterator to loop through each key/value from team_totals hash
		c = 0
		while c < arr[0].values.count

			# iterator to loop through each owner and create hash with owner id as key and category total as value
			i = 0
			sort_desc = true #direction to sort bat_hash because whip and era need to be sorted low to high and all others high to low
			arr.each do |a|
			  if a[:runs].nil? || a[:wins].nil?
			    bat_hash[o[i]] = 0
			  else
			    bat_hash[o[i]] = a.values[c]
					if a.keys[c] == :whip || a.keys[c] == :era
						sort_desc = false
					end
			  end
			  i += 1
			end
			# pass sorted bat_hash to rankv2 method
			result = {}
			# if key[:average] == :average
			# result = self.rankv2(bat_hash.sort_by{|k, v| v}.reverse.to_h)
			# sort descending order unless the category is whip or era
			if sort_desc
				result = self.rankv2(bat_hash.sort_by{|k, v| v}.reverse.to_h)
			else
				result = self.rankv2(bat_hash.sort_by{|k, v| v}.to_h)
			end
			team_cat_points[arr[0].keys[c]] = result
			standings.merge!(result){|key, oldval, newval| oldval + newval}
			c += 1
		end # end while loop
		# team_cat_points is a hash of hashes category as 1st level key and owner_id: number of points as value
		# ie {runs: {5: 10}}
		points_and_standings = []
		points_and_standings  << team_cat_points
		points_and_standings  << standings
		return points_and_standings
	end # end project_team_standings

end #end of class


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
