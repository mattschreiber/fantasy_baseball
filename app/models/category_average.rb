# This class will serve to calculate category averages used typically for generating reports such as the average number of 
# homeruns per team per season.

class CategoryAverage


# dynamically define methods that return category averages
# Loop throught the team_seasons table and use the column names to call the calc_one method
# which returns the average for the column (aka category). 
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