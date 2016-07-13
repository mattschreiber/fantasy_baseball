class Owner < ActiveRecord::Base
	has_many :team_seasons

	attr_reader :place_avg, :total_points_avg, :num_titles
	after_find do |owner|
    calc_team_averages
  end

	def num_titles
		self.team_seasons.where(place: 1).count
	end

	#pass in the column name for the category to calculate avg
	def calc_avg(category)
		self.team_seasons.average(:"#{category}").round(2).to_s
	end

private
	def calc_team_averages
		@num_titles = []
		if self.team_seasons.exists?
			self.team_seasons.each do |season|
				@place_avg = season[:place] + (@place_avg.nil? ? 0 : @place_avg)
				@total_points_avg = season[:total_points] + (@total_points_avg.nil? ? 0 : @total_points_avg)
				@num_titles << season[:place]
			end
			count = self.team_seasons.length
			@place_avg = (@place_avg / count.to_f).round(2)
			@total_points_avg = (@total_points_avg /count.to_f).round(2)
			@num_titles = @num_titles.select {|title| title == 1}.count
	end
	end
end

#  col_list.each {|col| pp hash[:"#{col}"] = owner.calc_avg("#{col}") }