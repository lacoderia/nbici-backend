class AppointmentsController < ApiController 
  include ErrorSerializer
  
  before_action :authenticate_user!, only: [:book]

  # POST /appointments/book
  def book
    begin
      appointment = Appointment.book(params, current_user)
      SendEmailJob.perform_later("booking", current_user, appointment)
      render json: appointment
    rescue Exception => e
      appointment = Appointment.new
      appointment.errors.add(:error_creating_appointment, e.message)
      render json: ErrorSerializer.serialize(appointment.errors), status: 500
    end
  end

end
