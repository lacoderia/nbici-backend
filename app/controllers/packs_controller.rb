class PacksController < ApplicationController
  before_action :set_pack, only: [:show, :update, :destroy]

  # GET /packs
  # GET /packs.json
  def index
    @packs = Pack.all

    render json: @packs
  end

  # GET /packs/1
  # GET /packs/1.json
  def show
    render json: @pack
  end

  # POST /packs
  # POST /packs.json
  def create
    @pack = Pack.new(pack_params)

    if @pack.save
      render json: @pack, status: :created, location: @pack
    else
      render json: @pack.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /packs/1
  # PATCH/PUT /packs/1.json
  def update
    @pack = Pack.find(params[:id])

    if @pack.update(pack_params)
      head :no_content
    else
      render json: @pack.errors, status: :unprocessable_entity
    end
  end

  # DELETE /packs/1
  # DELETE /packs/1.json
  def destroy
    @pack.destroy

    head :no_content
  end

  private

    def set_pack
      @pack = Pack.find(params[:id])
    end

    def pack_params
      params.require(:pack).permit(:description, :classes, :price, :special_price, :expiration)
    end
end
