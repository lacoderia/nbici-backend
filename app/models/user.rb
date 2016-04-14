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

  #EXPIRE CLASSES
  def self.expire_classes
    #TODO: create all the logic inside the SQL query
    users_with_purchases_and_classes_left = User.joins(:purchases).where("classes_left > ?", 0)

    users_with_purchases_and_classes_left.each do |user|
      user_classes_expiration = user.last_class_purchased + user.purchases.last.pack.expiration.days
      if user_classes_expiration <= Time.zone.now
        user.update_attribute(:classes_left, 0)
        user.purchases.last.update_attribute(:expired, true)
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
    User.joins("LEFT OUTER JOIN emails ON emails.user_id = users.id").where("classes_left = ? AND ((emails is null OR (emails.email_type != ? AND emails.email_status = ?)) OR (emails is not null AND NOT EXISTS (SELECT * from emails INNER JOIN user ON users.id = emails.user_id  WHERE email_type = ? AND email_status = ? AND created_at < ? AND created_at > ?)))", 1, "classes_left_reminder", "sent", "classes_left_reminder", "sent", Time.zone.now, Time.zone.now - 7.days).group("users.id").to_a
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
    users_query = User.joins("LEFT OUTER JOIN emails ON emails.user_id = users.id INNER JOIN purchases ON purchases.user_id = users.id").where("classes_left > ? AND last_class_purchased < ? AND ((emails is null OR (emails.email_type != ? AND emails.email_status = ?)) OR (emails is not null AND NOT EXISTS (SELECT * from emails INNER JOIN user ON users.id = emails.user_id WHERE email_type = ? AND email_status = ? AND created_at < ? AND created_at > ?)))", 0, Time.zone.now, "expiration_reminder", "sent", "expiration_reminder", "sent", Time.zone.now, Time.zone.now - 7.days).group(:id)
    users = []
    users_query.each do |user|
      user_classes_expiration = user.last_class_purchased + user.purchases.last.pack.expiration.days
      user_tolerance_for_remaining_classes = Time.zone.now + user.classes_left.days
      if user_classes_expiration <= user_tolerance_for_remaining_classes
        users << user
      end
    end
    return users
  
  end

end
