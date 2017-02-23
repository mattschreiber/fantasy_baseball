class OwnersController < ApplicationController
  before_action :set_owner, only: [:show, :edit, :update, :destroy]

  # GET /owners
  # GET /owners.json
  def index
    if params[:active].nil? or params[:active] == "true"
      active = true
      @owners = Owner.where("active= ?", active).sort_by(&:place_avg)
    else
      @owners = Owner.all.sort_by(&:place_avg)
    end

    respond_to do |format|
      format.html {render :index }
      format.js { render :index }
    end
    # @owners = @owners.sort_by(&:place_avg)
  end

  # GET /owners/1
  # GET /owners/1.json
  def show
    # used to display season history by owner
    @season = @owner.team_seasons.where(current_season: false)
    @batters = Player.includes(:battings).where("owner_id = ? AND battings.year = ?", params[:id], 2017).references(:battings)
    @pitchers = Player.includes(:pitchings).where("owner_id = ? AND pitchings.year = ?", params[:id], 2017).references(:pitchings)
  end

  # GET /owners/new
  def new
    @owner = Owner.new
  end

  # GET /owners/1/edit
  def edit
  end

  # POST /owners
  # POST /owners.json
  def create
    @owner = Owner.new(owner_params)
    @owner.id = Owner.all.last.id + 1 #manually set id
    respond_to do |format|
      if @owner.save
        format.html { redirect_to @owner, notice: 'Owner was successfully created.' }
        format.json { render :show, status: :created, location: @owner }
      else
        format.html { render :new }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /owners/1
  # PATCH/PUT /owners/1.json
  def update
    respond_to do |format|
      if @owner.update(owner_params)
        format.html { redirect_to edit_owner_path(@owner), notice: 'Owner was successfully updated.' }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html { render :edit }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /owners/1
  # DELETE /owners/1.json
  def destroy
    @owner.destroy
    respond_to do |format|
      format.html { redirect_to owners_url, notice: 'Owner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_owner
      @owner = Owner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def owner_params
      params.require(:owner).permit(:id, :first_name, :last_name, :team_name, :place_avg, :total_points_avg, :num_titles)
    end
end
