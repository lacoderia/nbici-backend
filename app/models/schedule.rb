class Schedule < ActiveRecord::Base
  belongs_to :instructor
  belongs_to :room
  has_many :appointments
end
