class StatsController < ApplicationController

  def index
    search_string = params[:q][0].upcase + params[:q].dup[1..-1].downcase unless params[:q].blank?
    if params[:year].nil?
      year = Time.now.year
    else
      year = params[:year][:id]
    end

    if params[:avail_players] == 'false'
      available = true
    else
      available = false
    end

  	if params[:pos].nil? || params[:pos] == 'a'
      @players = Player.search(search_string, params[:bat_pitch], year, available)
    else
      @players = Position.search(params[:pos], search_string, year, params[:bat_pitch], available)
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

  def compare
    year = Time.now.year
    @players = Player.compare_players(params[:players], params[:batter], year)

    if params[:batter] == "true"
      respond_to do |format|
        format.js {render :batter}
      end
    else
      respond_to do |format|
        format.js {render :pitcher}
      end
    end
  end

  private



  # def set_player
  #     @players = Player.all
  # end
end
