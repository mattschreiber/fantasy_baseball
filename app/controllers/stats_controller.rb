class StatsController < ApplicationController
  def index
  	if params[:pos]
      if (params[:pos] == 'sp' || params[:pos] == 'rp') and params[:bat_pitch] == "true"
        @players = Player.search(params[:q], params[:bat_pitch])
      elsif (params[:pos] == 'c' || params[:pos] == '1b' || params[:pos] == '2b' || params[:pos] == '3b' || params[:pos] == 'ss' || params[:pos] == 'of') and params[:bat_pitch] == 'false'
        @players = Player.search(params[:q], params[:bat_pitch])
      else
        @players = Position.search(params[:pos], params[:q])
      end
  		# 
      if params[:bat_pitch] != "false"
        respond_to do |format|
          format.html { render :batter }
        end
      else
        respond_to do |format|
          format.html {render :pitcher}
        end
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
