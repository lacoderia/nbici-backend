class Schedule < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :room
  belongs_to :alternate_instructor, :foreign_key => "alternate_instructor_id", :class_name => "Instructor"
  has_many :appointments, :dependent => :delete_all

  #scope :for_instructor_payments, -> {select("schedules.*, COUNT(appointments.*) as app_num").joins(:appointments, :instructor).where("appointments.status = ?", "FINALIZED").group("schedules.id").group_by{|schedule| schedule.datetime.to_date.to_s}}
  
  def self.weekly_scope
    start_day = Time.zone.now.beginning_of_day
    end_day = start_day + 8.days
    schedules = Schedule.where("datetime >= ? AND datetime < ?", start_day, end_day)

    #If thare are no schedules next week
    if schedules.empty?
      start_day = nil
      #Check if there are schedules anyday in the future
      schedules = Schedule.where("datetime >= ?", end_day).order(datetime: :asc)
      if not schedules.empty?
        start_day = schedules.first.datetime.beginning_of_day
        end_day = start_day + 8.days
        schedules = Schedule.where("datetime >= ? AND datetime < ?", start_day, end_day)
      end
    end

    return {schedules: schedules, start_day: start_day}
  end

  def self.weekly_scope_with_parameters schedules, start_day, end_day

    result_schedules = schedules.where("datetime >= ? AND datetime <= ?", start_day, end_day).order(datetime: :asc)

    #If thare are no schedules next week
    if result_schedules.empty?
      start_day = nil
      #Check if there are schedules anyday in the future
      result_schedules = schedules.where("datetime >= ?", end_day).order(datetime: :asc)
      if not result_schedules.empty?
        start_day = result_schedules.first.datetime
        end_day = start_day + 7.days
        result_schedules = schedules.where("datetime >= ? AND datetime <= ?", start_day, end_day).order(datetime: :asc)
      end

    end

    return {schedules: result_schedules, start_day: result_schedules.empty? ? start_day : result_schedules[0].datetime}

  end

  def bookings
    booked_bicycles = []
    active_bicycles = Bicycle.to_bicycle_array(self.room.distribution.active_seats)
    self.appointments.booked.each do |appointment|
      booked_bicycles << active_bicycles.find{|bicycle| bicycle.number == appointment.bicycle_number}
    end
    booked_bicycles.sort_by{|bicycle| bicycle.number}
  end
  
  def available_seats
    total_seats = self.room.distribution.total_seats
    booked_seats = self.appointments.booked.count
    return total_seats - booked_seats
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
