class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule

  STATUSES = [
    'BOOKED',
    'FINALIZED',
    'ANOMALY'
  ]
  
  validates :status, inclusion: {in: STATUSES}
  
  state_machine :status, :initial => 'BOOKED' do
    transition 'BOOKED' => 'FINALIZED', on: :finalize
    transition 'FINALIZED' => 'ANOMALY', on: :report_anomaly
  end

  def self.book params
    user = User.find(params[:user_id])
    schedule = Schedule.find(params[:schedule_id])
    bicycle_number = params[:bicycle_number].to_i
    description = params[:description]
    appointment = Appointment.new

    if (user.classes_left and user.classes_left >= 1) and (not schedule.bookings.index(bicycle_number))
      schedule.appointments << appointment = Appointment.create(user: user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)      
      user.update_attribute(:classes_left, user.classes_left - 1)
    elsif not user.classes_left or user.classes_left == 0 
      appointment.errors.add(:no_classes_left, "El usuario no cuenta con suficientes clases disponibles.")
    elsif schedule.bookings.index(bicycle_number)
      appointment.errors.add(:bicycle_already_booked, "Esa bicicleta ya fue seleccionada.")
    end
    appointment
  end
end
