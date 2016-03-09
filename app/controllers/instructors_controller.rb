class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :update, :destroy]

  # GET /instructors
  # GET /instructors.json
  def index
    @instructors = Instructor.all

    render json: @instructors
  end

  # GET /instructors/1
  # GET /instructors/1.json
  def show
    render json: @instructor
  end

  # POST /instructors
  # POST /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)

    if @instructor.save
      render json: @instructor, status: :created, location: @instructor
    else
      render json: @instructor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /instructors/1
  # PATCH/PUT /instructors/1.json
  def update
    @instructor = Instructor.find(params[:id])

    if @instructor.update(instructor_params)
      head :no_content
    else
      render json: @instructor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /instructors/1
  # DELETE /instructors/1.json
  def destroy
    @instructor.destroy

    head :no_content
  end

  private

    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    def instructor_params
      params.require(:instructor).permit(:first_name, :last_name, :email, :picture)
    end
end
