class PlayersController < ApplicationController
  def edit
  	@player = Player.find_by("id = ?", params[:id])
  end
  def player_params
      params.require(:player).permit(:id)
    end
end
