class AppointmentsController < ApiController 
  include ErrorSerializer
  
  before_action :authenticate_user!, only: [:book]

  # POST /appointments/book
  def book
    begin
      appointment = Appointment.book(params, current_user)
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

end
