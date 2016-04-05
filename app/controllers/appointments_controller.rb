class AppointmentsController < ApplicationController
  include ErrorSerializer
  
  before_action :set_appointment, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:book]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = Appointment.all

    render json: @appointments
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    render json: @appointment
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      render json: @appointment, status: :created, location: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])

    if @appointment.update(appointment_params)
      head :no_content
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy

    head :no_content
  end

  # POST /appointments/book
  def book
    begin
      params[:user_id] = current_user.id
      appointment = Appointment.book(params)
      if appointment.errors.empty?
        render json: appointment
      else
        render json: ErrorSerializer.serialize(appointment.errors), status: 500
      end
    rescue Exception => e
      appointment = Appointment.new
      appointment.errors.add(:error_creating_appointment, e.message)
      render json: ErrorSerializer.serialize(appointment.errors), status: 500
    end
  end

  private

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:user_id, :status, :schedule_id, :bicycle_number, :start, :description, :anomaly)
    end
end
