class NotesController < ApplicationController

  before_action :set_player, only: [:show, :edit, :update, :destroy]



  def create
    @note = Note.new(note_params)
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render json: @note }
      else
        # format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:id, :note, :owner_id, :player_id)
    end

end
