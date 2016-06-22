class PacksController < ApplicationController

  # GET /packs
  # GET /packs.json
  def index
    @packs = Pack.all

    render json: @packs
  end
end
