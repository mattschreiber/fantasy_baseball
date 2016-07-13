class Owner < ActiveRecord::Base
	has_many :team_seasons, dependent: :destroy

	# after_find do |owner|
 #    @avg_place = owner.team_seasons.average(:place).to_s
 #    @num_titles = owner.team_seasons.where(place: 1).count
 #  end

	def num_titles
		self.team_seasons.where(place: 1).count
	end

	#pass in the column name for the category to calculate avg
	def calc_avg(category)
		self.team_seasons.average(:"#{category}").round(2).to_s
	end
end
