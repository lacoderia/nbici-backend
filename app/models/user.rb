class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  #        :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_and_belongs_to_many :roles
  has_many :emails
  has_many :cards
  has_many :appointments
  has_many :purchases

  def role?(role)
    return !!self.roles.find_by_name(role)
  end

  def register
    user = User.find_by_email(self.email)
    if user
      self.errors.add(:registration, "Ya existe un usuario registrado con ese correo electrónico.")
      false
    else
      true
    end

  end

end
