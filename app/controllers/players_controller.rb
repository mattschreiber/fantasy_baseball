class PlayersController < ApplicationController

	before_action :set_player, only: [:show, :edit, :update, :destroy]
  
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to edit_player_path(@player), notice: 'Player was successfully updated.' }
        # format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        # format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_starter
    year = Time.now.year
    @player = Player.find(params[:player_id])
    @player.update(player_params)
    owner_id = @player.owner_id
    # set last parameter to true for batters or false for pitchers
    # this is do to Batting and pitching sharing code
    @batter_totals = Batting.team_totals(year, owner_id, true)
    @pitcher_totals = Pitching.team_totals(year, owner_id, false)

    # @pitcher_totals = Pitching.team_totals(year, params[:id], false)
    respond_to do |format|
      format.js 
    end
    
  end

private

  def set_player
      @player = Player.find(params[:id])
    end

  def player_params
      params.require(:player).permit(:id, :first_name, :last_name, :avail, :owner_id, :starter)
  end
end
