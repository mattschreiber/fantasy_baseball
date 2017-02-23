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

private

  def set_player
      @player = Player.find(params[:id])
    end

  def player_params
      params.require(:player).permit(:id, :first_name, :last_name, :avail, :owner_id)
  end
end
