class Schedule < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :room
  has_many :appointments

  def self.weekly_scope
    start_day = Time.zone.now.beginning_of_day
    end_day = start_day + 8.days
    Schedule.where("datetime >= ? AND datetime < ?", start_day, end_day)
  end

  def bookings
    booked_bicycles = []
    active_bicycles = Bicycle.to_bicycle_array(self.room.distribution.active_seats)
    self.appointments.where("status = ?", "BOOKED").each do |appointment|
      booked_bicycles << active_bicycles.find{|bicycle| bicycle.number == appointment.bicycle_number}
    end
    booked_bicycles.sort_by{|bicycle| bicycle.number}
  end

  def inactive_seats
    eval(self.room.distribution.inactive_seats)
  end

  def bicycle_exists? bicycle_number
    active_bicycles = Bicycle.to_bicycle_array(self.room.distribution.active_seats)
    if active_bicycles.find{|bicycle| bicycle.number == bicycle_number}
      return true
    else
      return false
    end    
  end
  
end
