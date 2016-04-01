class SchedulesController < ApplicationController
  include ErrorSerializer
  include BookingSerializer

  before_action :set_schedule, only: [:show, :update, :destroy, :bookings]

  # GET /schedules
  # GET /schedules.json
  def index
    @schedules = Schedule.all

    render json: @schedules
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    if @user.errors.empty?
      render json: @schedule
    else
      render json: ErrorSerializer.serialize(@schedule.errors)
    end
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      render json: @schedule, status: :created, location: @schedule
    else
      render json: ErrorSerializer.serialize(@schedule.errors)
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    @schedule = Schedule.find(params[:id])

    if @schedule.update(schedule_params)
      head :no_content
    else
      render json: ErrorSerializer.serialize(@schedule.errors)
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy

    head :no_content
  end

  # CUSTOM ACTIONS

  # GET /schedules/weekly_scope
  def weekly_scope
    schedules = Schedule.weekly_scope

    render json: schedules
  end

  # GET /schedules/(:id)/bookings
  def bookings
    bookings = @schedule.bookings
    render json: BookingSerializer.serialize(bookings)
  end

  private

    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:instructor_id, :room_id, :datetime)
    end
end
