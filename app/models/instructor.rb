class Instructor < ActiveRecord::Base
  has_many :schedules
  belongs_to :admin_user
end
