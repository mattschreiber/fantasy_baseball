class SeasonsController < ApplicationController

	def index
		@current_seasons = TeamSeason.rank
	end

end
