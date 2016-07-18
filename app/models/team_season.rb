class TeamSeason < ActiveRecord::Base
	belongs_to :owner

	default_scope {order year: :desc}


	CATEGORIES = ["total_run", "total_hr", "total_rbi", "total_sb", "total_avg", "total_win", "total_k", "total_sv", "total_era", "total_whip"]

	def self.calc_season_points (year)
		# todo
		# need to still loop through each category (Class Variable?)
		# sort doesn't take into account ties 
		
		standings = {}

		CATEGORIES.each do |cat|
			hash = {}
			sorted_hash = {}
			h = {}

			if cat == "total_era" || cat == "total_whip"
				hash = TeamSeason.where("year = ?", year).pluck(:owner_id, cat).to_h
				sorted_hash = hash.sort_by{|owner, run| run}.to_h
				sorted_hash.keys.map do |k| 
					h["#{k}"] = sorted_hash.keys.reverse.index(k) + 1
				end
			else
				hash = TeamSeason.where("year = ?", year).pluck(:owner_id, cat).to_h
				sorted_hash = hash.sort_by{|owner, run| run}.to_h
				sorted_hash.keys.map do |k| 
					h["#{k}"] = sorted_hash.keys.index(k) + 1
				end
			end
			standings.merge!(h){|key, oldval, newval| oldval + newval}
		end	
		standings = standings.map{|k, v| [Owner.find(k).first_name, v]}.to_h	
		return standings
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
