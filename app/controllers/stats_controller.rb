class StatsController < ApplicationController

  def index
  	if params[:pos]
      #hack if someone enters Bat incorrect position
      if (params[:pos] == 'sp' || params[:pos] == 'rp') and params[:bat_pitch] == "true"
        @players = Player.search(params[:q], params[:bat_pitch])
      #hack if someone enters Pitch with an incorrect position
      elsif (params[:pos] == 'c' || params[:pos] == '1b' || params[:pos] == '2b' || params[:pos] == '3b' || params[:pos] == 'ss' || params[:pos] == 'of') and params[:bat_pitch] == 'false'
        @players = Player.search(params[:q], params[:bat_pitch])
      elsif params[:pos] == 'a'
        @players = Player.search(params[:q], params[:bat_pitch])
      else
        # search by position    
        @players = Position.search(params[:pos], params[:q])
      end
  		# render batters 
      if params[:bat_pitch] != "false"
        respond_to do |format|
          format.html { render :batter }
        end
      #render pitchers 
      else
        respond_to do |format|
          format.html {render :pitcher}
        end
      end
    # search by player name without a position 
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

  def partial
    @h = {}
    player = Player.all.first
    @h[:first] = player.first_name
    @h[:last] = player.last_name
    @h[:runs] = player.battings.first.runs
  end

  private

  def set_player
      @players = Player.all
  end
end
