class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  #        :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  before_create :assign_coupon

  has_and_belongs_to_many :roles

  has_many :emails
  has_many :expirations
  has_many :cards
  has_many :appointments
  has_many :purchases
  has_many :credit_modifications
  has_many :referrals, :foreign_key => "owner_id", :class_name => "Referral"
  
  
  accepts_nested_attributes_for :credit_modifications
  accepts_nested_attributes_for :purchases
  
  scope :with_appointments_summary, -> {select("users.*, COUNT(CASE WHEN appointments.status = 'BOOKED' THEN 1 END) as booked, COUNT(CASE WHEN appointments.status = 'CANCELLED' THEN 1 END) as cancelled, COUNT(CASE WHEN appointments.status = 'FINALIZED' THEN 1 END) as finalized").joins(:appointments).group("users.id")}

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
  
  #CONEKTA
  def get_or_create_conekta_customer
    if self.conekta_id 
      customer = Conekta::Customer.find(self.conekta_id)      
    else
      customer = Conekta::Customer.create({
        name: "#{self.first_name} #{self.last_name}",
        email: self.email
      })
      self.update_attribute(:conekta_id, customer.id)
    end
    return customer
  end

  #EXPIRE CLASSES
  def self.expire_classes
    #TODO: create all the logic inside the SQL query

    #BY PURCHASE
    users_with_classes_left = User.where("classes_left > ?", 0)
    users_with_classes_left.each do |user|
      if user.expiration_date <= Time.zone.now
        Expiration.create(user_id: user.id, classes_left: user.classes_left, last_class_purchased: user.last_class_purchased)
        user.update_attribute(:classes_left, 0)
      end      
    end
 
  end 

  #REMINDERS
  def self.send_classes_left_reminder
    users = self.with_one_class_left
    users.each do |user|
      SendReminderJob.perform_later("classes_left_reminder", user, nil)
    end
  end

  #Gets users with 1 class left and that have no classes_left_remider emails, or that it has a reminder email but sent more than a week ago
  def self.with_one_class_left
    User.select("users.*, users.id AS user_id").joins("LEFT OUTER JOIN emails ON emails.user_id = users.id").where("classes_left = ? AND (emails is null OR (NOT EXISTS (SELECT * FROM emails INNER JOIN user ON users.id = emails.user_id  WHERE emails.user_id = user_id AND email_type = ? AND email_status = ? AND emails.created_at < ? AND emails.created_at > ?)))", 1, "classes_left_reminder", "sent", Time.zone.now, Time.zone.now - 7.days).group("users.id").to_a
  end

  def self.send_expiration_reminder
    users = self.with_expiring_classes
    users.each do |user|
      SendReminderJob.perform_later("expiration_reminder", user, nil)
    end
  end
  
  #Gets users with purchases and that have no expiration_reminder emails, or that it has a reminder email but sent more than a week ago
  def self.with_expiring_classes
    #TODO: create all the logic inside the SQL query
    users_query = User.select("users.*, users.id AS user_id").joins("LEFT OUTER JOIN emails ON emails.user_id = users.id INNER JOIN purchases ON purchases.user_id = users.id").where("classes_left > ? AND last_class_purchased < ? AND (emails is null OR (NOT EXISTS (SELECT * FROM emails INNER JOIN user ON users.id = emails.user_id WHERE emails.user_id = user_id AND email_type = ? AND email_status = ? AND emails.created_at < ? AND emails.created_at > ?)))", 0, Time.zone.now, "expiration_reminder", "sent", Time.zone.now, Time.zone.now - 7.days).group(:id)
    users = []
    users_query.each do |user|
      user_tolerance_for_remaining_classes = Time.zone.now + user.classes_left.days
      if user.expiration_date and (user.expiration_date <= user_tolerance_for_remaining_classes)
        users << user
      end
    end
    return users
  
  end

  def self.create_expiration_date_for_users_with_purchases 

    users_with_purchases = User.joins(:purchases)
    users_with_purchases.each do |user|
      day_count = 0
      user.purchases.each do |purchase|
        day_count += purchase.pack.expiration
      end
      
      user.expiration_date = user.last_class_purchased + day_count.days
      user.save!
    end

  end

  def self.create_coupons_for_all_users
    User.where(coupon: nil).each do |user|
      coupon = Discount.generate
      user.update_attribute(:coupon, coupon)
    end
  end

  private 

    def assign_coupon
      self.coupon = Discount.generate_coupon
    end
 
end
