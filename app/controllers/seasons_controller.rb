class SeasonsController < ApplicationController

	def index
		@current_seasons = CurrentSeason.ratio_standings
	end

	def historical
		@category_average = CategoryAverage.new
		# render json: "soon to be my page"
		# render :template => 'seasons/historical'
	end

	def import
		TeamSeason.import(params[:file], params[:current])
		redirect_to seasons_url, notice: "Current Season imported"
	end

end
