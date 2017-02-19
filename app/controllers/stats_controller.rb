class StatsController < ApplicationController

  def index

    @players = []
    if params[:year].nil?
      year = Time.now.year
    else
      year = params[:year][:id]
    end
        
  	if params[:pos].nil? || params[:pos] == 'a'
      @players = Player.search(params[:q], params[:bat_pitch], year)
    else
      @players = Position.search(params[:pos], params[:q], year)
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


  private



  # def set_player
  #     @players = Player.all
  # end
end
