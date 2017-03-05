class SeasonsController < ApplicationController

	def index
		@current_seasons = CurrentSeason.ratio_standings
	end

	def historical
		@category_average = CategoryAverage.calc_by_place
	end

	def projected_standings
		@standings = Standing.build_standings
	end

	def import
		TeamSeason.import(params[:file], params[:current])
		redirect_to seasons_url, notice: "Current Season imported"
	end

end
