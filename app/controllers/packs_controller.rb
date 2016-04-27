class PacksController < ApplicationController
  before_action :set_pack, only: [:show]

  # GET /packs
  # GET /packs.json
  def index
    @packs = Pack.all

    render json: @packs
  end
end
