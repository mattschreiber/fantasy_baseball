class SeasonsController < ApplicationController

	def index
		@current_seasons = CurrentSeason.ratio_standings
	end

end
