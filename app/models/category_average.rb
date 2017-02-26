# This class will serve to calculate category averages used typically for generating reports such as the average number of 
# homeruns per team per season.

class CategoryAverage 
	include Query::TeamSeasonQuery # models/query

	attr_reader :run_avg, :hr_avg, :rbi_avg, :sb_avg, :avg_avg, :win_avg, :k_avg, :sv_avg, :era_avg, :whip_avg

	CATEGORIES = [:total_run, :total_hr, :total_rbi, :total_sb, :total_avg, :total_win, :total_k, :total_sv, :total_era, :total_whip]

	CAT_POINTS = [:run_points, :hr_points, :rbi_points, :sb_points, :avg_points,
								:win_points, :k_points, :sv_points, :era_points, :whip_points]

	CATEGORIES_HASH = {run_points: "total_run", hr_points: "total_hr", rbi_points: "total_rbi",
										  sb_points: "total_sb", avg_points: "total_avg", win_points: "total_win",
										  k_points: "total_k", sv_points: "total_sv", 
										  era_points: "total_era", whip_points: "total_whip"}

	def initialize (year)

		@run_avg = calc_avg_year(year, "total_run")
		@hr_avg = calc_avg_year(year, "total_hr")
		@rbi_avg = calc_avg_year(year, "total_rbi")
		@sb_avg = calc_avg_year(year, "total_sb")
		@avg_avg = calc_avg_year(year, "total_avg")

		@win_avg = calc_avg_year(year, "total_win")
		@k_avg = calc_avg_year(year, "total_k")
		@sv_avg = calc_avg_year(year, "total_sv")
		@era_avg = calc_avg_year(year, "total_era")
		@whip_avg = calc_avg_year(year, "total_whip")

	end


# dynamically define methods that return category averages
# Loop through the team_seasons table and use the column names to call filter method
# which returns the average for the CATEGORIES. 
# The filter method is defined in the team_season_query.rb 
# methods naming convention is Categories_avg (ex. total_hr_avg)

	# CATEGORIES.each do |cat|
	# 	define_method("#{cat}_avg") do 
	# 		self.class.calc_one("#{cat}")
	# 	end
	# end

	def calc_avg_year (year, category)
		TeamSeason.where(year: year).average(category)
	end


	def self.calc_one(cat_points, category)
		TeamSeason.where("#{cat_points} = 8 AND current_season = false AND year BETWEEN 2012 AND 2016").average("#{category}")
	end

	def self.calc_all
		#class method that returns hash of category averages
		hash = {}
		CATEGORIES.each do |name|
			hash[:"#{name}"] = calc_one(name)
		end
		return hash
	end

	def self.calc_by_place
		#class method that returns category averages for a given point total
		#i.e. average number of runs where run points were 8
		hash = {}
		CATEGORIES_HASH.each do |k, v|
			hash[:"#{v}"] = calc_one(k, v)
		end
		return hash

	end

	# return list of avg methods 
	def self.avg_methods
		self.instance_methods.grep(/_avg/)
	end

# dynamically define methods that return the average for a particular statistical category by year and/or place
# The method accepts a hash of query parameters and a string that represents the name of the column to pass to the average method. 
# The filter method is defined in the team_season_query.rb for available hash parameters
# Example method hr_by_place(hash) 
# hash keys :year, :place, :category
# CategoryAverage.instance_methods.grep(/place/) for list of available instance methods

	# CATEGORIES.each do |col|
	# 	define_method("#{col}".sub("total_", "")+"_by_place") do |hash|
	# 		filter(hash).average(hash[:category])
	# 	end
	# end

	#return list of place methods
	def self.place_methods
		self.instance_methods.grep(/_place/)
	end


end