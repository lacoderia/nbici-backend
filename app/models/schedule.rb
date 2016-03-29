class Schedule < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :room
  has_many :appointments

  def self.weekly_scope
    start_day = Time.zone.now.beginning_of_day
    end_day = start_day + 8.days
    Schedule.where("datetime >= ? AND datetime < ?", start_day, end_day)
  end
  
end
