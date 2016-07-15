# This class will serve to calculate category averages such as the average number of 
# homeruns per team per season.

class CategoryAverage

	# CATEGORIES = ["total_run_avg", "total_hr_avg", "total_rbi_avg", "total_sb_avg", 
	# 	"total_avg_avg", "total_win_avg", "total_k_avg", "total_sv_avg", "total_era_avg", "total_whip_avg"]

# dynamically define methods that return category averages
	TeamSeason.column_names.each do |cat|
		define_method("#{cat}_avg") do
			self.class.calc_one("#{cat}")
		end
	end

	def self.calc_one(category)
		TeamSeason.average(:"#{category}").to_s
	end

	def self.calc_all
		#class method that returns hash of category averages. hash keys match class attributes
		hash = {}
		TeamSeason.column_names.each do |name|
			hash[:"#{name}_avg"] = calc_one(name) unless TeamSeason.column_for_attribute(name).type == :datetime
		end
		return hash
	end



end