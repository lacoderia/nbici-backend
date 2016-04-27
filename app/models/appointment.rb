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

  def cancel_with_time_check

    if Time.zone.now < (self.start - 24.hours)
      self.cancel!
      self.user.update_attribute(:classes_left, self.user.classes_left + 1)
    else
      raise "Sólo se pueden cancelar clases con 24 horas de anticipación."
    end    
  end

  def self.finalize
    appointments_to_finalize = Appointment.where("status = ? AND start < ?", "BOOKED", Time.zone.now - 1.hour)
    appointments_to_finalize.each do |appointment|
      appointment.finalize!
    end
  end

  def self.book params, current_user

    user = current_user 
    schedule = Schedule.find(params[:schedule_id])
    bicycle_number = params[:bicycle_number].to_i
    description = params[:description]
    appointment = Appointment.new
    
    if schedule.datetime <= Time.zone.now
      raise "La clase ya está fuera de horario."
    end
      
    if not schedule.bicycle_exists?(bicycle_number)
      raise "Esa bicicleta no existe, por favor intenta nuevamente."
    end

    if (user.classes_left and user.classes_left >= 1) and (not schedule.bookings.find{|bicycle| bicycle.number == bicycle_number})

      schedule.appointments << appointment = Appointment.create!(user: user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)      
      user.update_attribute(:classes_left, user.classes_left - 1)
    elsif not user.classes_left or user.classes_left == 0 
      raise "Ya no tienes clases disponibles, adquiere más para continuar."
    elsif schedule.bookings.find{|bicycle| bicycle.number == bicycle_number}
      raise "La bicicleta ya fue reservada, por favor intenta con otra."
    end
    appointment
  end
end
