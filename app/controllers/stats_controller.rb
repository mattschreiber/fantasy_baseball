class StatsController < ApplicationController

  def index
    @players = []
  	if params[:pos].nil? || params[:pos] == 'a'
      @players = Player.search(params[:q], params[:bat_pitch])
    else
      @players = Position.search(params[:pos], params[:q])
    end
    if params[:bat_pitch] != "false"
        respond_to do |format|
          format.js { render :batter}
          format.html { render :batter }
          format.json { render :batter }
        end
      else
        respond_to do |format|
          format.js {render :pitcher}
          format.html {render :pitcher}
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

  # def set_player
  #     @players = Player.all
  # end
end
