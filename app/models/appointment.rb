class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule

  STATUSES = [
    'BOOKED',
    'CANCELLED',
    'FINALIZED',
    'ANOMALY'
  ]
  
  validates :status, inclusion: {in: STATUSES}
  
  state_machine :status, :initial => 'BOOKED' do
    transition 'BOOKED' => 'FINALIZED', on: :finalize
    transition 'BOOKED' => 'CANCELLED', on: :cancel
    transition 'FINALIZED' => 'ANOMALY', on: :report_anomaly
  end

  def self.book params, current_user
    user = current_user 
    schedule = Schedule.find(params[:schedule_id])
    bicycle_number = params[:bicycle_number].to_i
    description = params[:description]
    appointment = Appointment.new

    if (user.classes_left and user.classes_left >= 1) and (not schedule.bookings.index(bicycle_number))

      if schedule.inactive_seats.index(bicycle_number)
        raise "La bicicleta #{bicycle_number} está inactiva para la schedule #{schedule.id}."
      end

      schedule.appointments << appointment = Appointment.create(user: user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)      
      user.update_attribute(:classes_left, user.classes_left - 1)
    elsif not user.classes_left or user.classes_left == 0 
      raise "El usuario no cuenta con suficientes clases disponibles."
    elsif schedule.bookings.index(bicycle_number)
      raise "La bicicleta #{bicycle_number} ya fue seleccionada para la schedule #{schedule.id}."
    end
    appointment
  end
end
