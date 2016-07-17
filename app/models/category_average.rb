# This class will serve to calculate category averages used typically for generating reports such as the average number of 
# homeruns per team per season.

class CategoryAverage 
	include Query::TeamSeasonQuery # models/query

# dynamically define methods that return category averages
# Loop through the team_seasons table and use the column names to call filter method
# which returns the average for the column (aka category). 
# The filter method is defined in the team_season_query.rb 
# methods naming convention is TeamSeason.column_name_avg (ex. total_hr_avg)
# Method expects hash = {category: "TeamSeason.column" }

	TeamSeason.column_names.each do |cat|
		define_method("#{cat}_avg") do |hash|
			filter(hash).to_s
			# calc_one("#{cat}")
		end
	end

	# def calc_one(category)
	# 	TeamSeason.average(:"#{category}").to_s
	# end

	def self.calc_all
		#class method that returns hash of category averages. hash keys match class attributes
		hash = {}
		TeamSeason.column_names.each do |name|
			hash[:"#{name}_avg"] = calc_one(name) unless TeamSeason.column_for_attribute(name).type == :datetime
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
# Example method hr_by_place(hash, "total_hr")
# CategoryAverage.instance_methods.grep(/place/) for list of available instance methods

	TeamSeason.column_names.each do |col|
		define_method("#{col}".sub("total_", "")+"_by_place") do |hash|
			filter(hash).average(hash[:category]).to_s
		end
	end

	#return list of place methods
	def self.place_methods
		self.instance_methods.grep(/_place/)
	end


end