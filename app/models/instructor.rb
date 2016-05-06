class Instructor < ActiveRecord::Base
  has_many :schedules
  has_one :admin_user, :dependent => :destroy

  accepts_nested_attributes_for :admin_user
end
