class DistributionsController < ApplicationController
  before_action :set_distribution, only: [:show, :update, :destroy]

  # GET /distributions
  # GET /distributions.json
  def index
    @distributions = Distribution.all

    render json: @distributions
  end

  # GET /distributions/1
  # GET /distributions/1.json
  def show
    render json: @distribution
  end

  # POST /distributions
  # POST /distributions.json
  def create
    @distribution = Distribution.new(distribution_params)

    if @distribution.save
      render json: @distribution, status: :created, location: @distribution
    else
      render json: @distribution.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /distributions/1
  # PATCH/PUT /distributions/1.json
  def update
    @distribution = Distribution.find(params[:id])

    if @distribution.update(distribution_params)
      head :no_content
    else
      render json: @distribution.errors, status: :unprocessable_entity
    end
  end

  # DELETE /distributions/1
  # DELETE /distributions/1.json
  def destroy
    @distribution.destroy

    head :no_content
  end

  private

    def set_distribution
      @distribution = Distribution.find(params[:id])
    end

    def distribution_params
      params.require(:distribution).permit(:height, :width, :description, :inactive_seats, :active_seats, :total_seats)
    end
end
