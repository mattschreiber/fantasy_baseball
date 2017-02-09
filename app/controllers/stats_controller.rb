class StatsController < ApplicationController
  def index
  	@players = Player.all
  	if params[:pos]
  		@players = Position.search(params[:pos], params[:q])
  	elsif params[:q]
  		@players = Player.search(params[:q])
  	else
  		@players = Player.all
  	end
  end
end
