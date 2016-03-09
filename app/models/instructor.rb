class Instructor < ActiveRecord::Base
  has_many :schedules
end
