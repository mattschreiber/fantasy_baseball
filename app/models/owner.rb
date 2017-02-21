class Owner < ActiveRecord::Base
	has_many :team_seasons, dependent: :nullify
	has_many :players


	attr_reader :place_avg, :total_points_avg, :num_titles, :total_avg_avg

	# use callback to check if an owner has any associated team_seasons
	# and if found, set values for calculated fields.  I chose to go this route
	# in order to keep from storing calculated fields in db and also because the 
	#calc_team_averages method only requires to queries of the db to gather most commonly
	# used fields
	# after_find do |owner|
 #    calc_team_averages
 #  end

	def num_titles
		self.team_seasons.where(place: 1).count
	end

	def total_points_avg
		@total_points_avg = 0
		count = 0
		self.team_seasons.where(current_season: false).each do |season|
			@total_points_avg = season[:total_points] + (@total_points_avg.nil? ? 0 : @total_points_avg)
			count = count + 1
		end
		if @total_points_avg > 0
			@total_points_avg = (@total_points_avg / count.to_f).round(2) 
		else
			@total_points_avg = 0
		end
	end

	def place_avg
		@place_avg = 0
		count = 0
		self.team_seasons.where(current_season: false).each do |season|
			@place_avg = season[:place] + (@place_avg.nil? ? 0 : @place_avg)
			count = count + 1
		end
		if @place_avg > 0
			@place_avg = (@place_avg / count.to_f).round(2)
		else
			@place_avg = 10
		end
		
	end

	#pass in the column name for the category to calculate avg
	def calc_avg(category)
		self.team_seasons.average(:"#{category}").round(2).to_s
	end

	def name
		"#{first_name} #{last_name}"
	end


private
	# def calc_team_averages
	# 	@num_titles = []
	# 	@place_avg = 0
	# 	@total_points_avg = 0
	# 	if self.team_seasons.exists?
	# 		self.team_seasons.each do |season|
	# 			@place_avg = season[:place] + (@place_avg.nil? ? 0 : @place_avg)
	# 			@total_points_avg = season[:total_points] + (@total_points_avg.nil? ? 0 : @total_points_avg)
	# 			@total_avg_avg = season[:total_avg] + (@total_avg_avg.nil? ? 0 : @total_avg_avg)
	# 			@num_titles << season[:place]
	# 		end
	# 		count = self.team_seasons.length
	# 		@place_avg = (@place_avg / count.to_f).round(2)
	# 		@total_points_avg = (@total_points_avg /count.to_f).round(2)
	# 		@total_avg_avg = (@total_avg_avg / count).round(4)
	# 		@num_titles = @num_titles.select {|title| title == 1}.count
	# 	else
	# 		#set place to last if owner doesn't have any records in team_seasons
	# 		#This is primarily so that sort works properly in the index action for the owners controller
	# 		@place_avg = 10.0
	# 	end
	# end
end

#  col_list.each {|col| pp hash[:"#{col}"] = owner.calc_avg("#{col}") }