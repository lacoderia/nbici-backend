class Waitlist < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :user

  STATUSES = [
    'WAITING',
    'ASSIGNED',
    'REIMBURSED'
  ]
  
  validates :status, inclusion: {in: STATUSES}

  state_machine :status, :initial => 'WAITING' do
    transition 'WAITING' => 'ASSIGNED', on: :assign
    transition 'WAITING' => 'REIMBURSED', on: :reimburse
  end

  def self.create_and_send_email(schedule_id, user) 
    
    #credit validation
    if not user.classes_left or user.classes_left == 0 
      raise "Ya no tienes clases disponibles, adquiere más para continuar."
    end

    schedule = Schedule.find(schedule_id)

    #full validation
    if schedule.available_seats > 0
      raise "La clase todavía tiene asientos disponibles."
    end

    #time validation
    if Time.zone.now < (schedule.datetime - 12.hours)
      user.update_attribute(:classes_left, user.classes_left - 1)    
      waitlist = Waitlist.create!(schedule: schedule, user: user, status: "WAITING")
      SendEmailJob.perform_later("waitlist", user, waitlist)
      return waitlist
    else
      raise "Sólo se puede ingresar a lista de espera con al menos 12 horas de anticipación."
    end

  end
end
