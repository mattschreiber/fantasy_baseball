class SeasonsController < ApplicationController

	def index
		@current_seasons = CurrentSeason.ratio_standings
	end

	def import
		TeamSeason.import(params[:file])
		redirect_to seasons_url, notice: "Current Season imported"
	end

end
