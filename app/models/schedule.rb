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
    booked_seats = []
    self.appointments.each do |appointment|
      booked_seats << appointment.bicycle_number
    end
    booked_seats.sort
  end

  def inactive_seats
    eval(self.room.distribution.inactive_seats)
  end
  
end
