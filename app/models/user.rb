class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :emails
  has_many :cards
  has_many :appointments
  has_many :purchases
end
