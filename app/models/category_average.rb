# This class will serve to calculate category averages used typically for generating reports such as the average number of 
# homeruns per team per season.

class CategoryAverage 
	include Query::TeamSeasonQuery # models/query

# dynamically define methods that return category averages
# Loop through the team_seasons table and use the column names to call the calc_one method
# which returns the average for the column (aka category). 
# methods naming convention is TeamSeason.column_name_avg (ex. total_hr_avg)

	TeamSeason.column_names.each do |cat|
		define_method("#{cat}_avg") do
			calc_one("#{cat}")
		end
	end

# dynamically define methods that return the average for a particular statistical category
# The method accepts a hash of query parameters and a string that represents the name of the column to pass to the average method. 
# The filter method is defined in the team_season_query.rb for available hash parameters
# Example method call object.hr_by_place(hash, "total_hr")
# CategoryAverage.instance_methods.grep(/place/) for list of available instance methods

	TeamSeason.column_names.each do |col|
		define_method("#{col}".sub("total_", "")+"_by_place") do |hash, category|
			filter(hash).average(category.to_sym).to_s
		end
	end

	def calc_one(category)
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

	def test_filter (hash)
		filter(hash)
	end

	# # return ActiveRecord::Relations based on query params
	# # accepted params :year, :place
	# def self.filter(attributes)
	# 	case 
	# 	when attributes[:place].present? && attributes[:year].present?
	# 		TeamSeason.where("place = :place and year = :year", place: attributes[:place], year: attributes[:year])
	# 	when attributes[:place]
	# 		TeamSeason.where("place = :place", place: attributes[:place])
	# 	when attributes[:year]
	# 		TeamSeason.where("year = :year", year: attributes[:year])				
	# 	else
	# 			return error_msg = "Invalid search parameters"
	# 	end
	# end

	# def filter(attributes)
	# 	self.class.filter(attributes)
	# end


end