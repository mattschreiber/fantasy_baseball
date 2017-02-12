class StatsController < ApplicationController
  def index
  	if params[:pos]
  		@players = Position.search(params[:pos], params[:q])
      respond_to do |format|
          format.html { render :batter }
      end
  	else params[:q]
  		@players = Player.search(params[:q], params[:bat_pitch])
      if params[:bat_pitch] != "false"
        respond_to do |format|
          format.html { render :batter }
          format.json { render :batter }
        end
      else
        respond_to do |format|
          format.html {render :pitcher}
        end
      end
  	end
  end
end
