class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  #        :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  before_create :assign_coupon
  before_update :check_staff

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :promotions

  has_many :emails
  has_many :expirations
  has_many :cards
  has_many :appointments
  has_many :purchases
  has_many :credit_modifications
  has_many :referrals, :foreign_key => "owner_id", :class_name => "Referral"
  has_many :menu_purchases
  has_many :available_streaming_classes
  has_many :waitlists
  
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

  def send_coupon_by_email email
    SendEmailJob.perform_later("send_coupon", self, email)
    return {coupon: self.coupon, email: email}
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
      if user.expiration_date and user.expiration_date <= Time.zone.now
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
      coupon = Discount.generate_coupon
      user.update_attribute(:coupon, coupon)
    end
  end

  
  # N-bici and N-box integration

  # Internal methods   
  
  def validate_email email
    if self.email == email
      return true
    else
      user = User.find_by_email(email)
      if user
        return false
      else
        return true
      end
    end
  end

  def update_account email, password

    crypt = ActiveSupport::MessageEncryptor.new(ENV['SYNCH_KEY'])
    encrypted_password = crypt.encrypt_and_sign(password)
    return self.update_attributes!(email: email, password: password, password_confirmation: password, u_password: encrypted_password)
    
  end

  def migrate_classes_left classes_left, expiration_date

    final_classes_left = self.classes_left ? self.classes_left : 0
    final_classes_left += classes_left ?  classes_left.to_i : 0

    if expiration_date and (not expiration_date.empty?) and (Time.zone.now < expiration_date.to_datetime)

      expiration_time_left_in_seconds = expiration_date.to_datetime.to_i - Time.zone.now.to_i 

      if self.expiration_date
        final_expiration_date = self.expiration_date + expiration_time_left_in_seconds.seconds
      else
        final_expiration_date = expiration_date.to_datetime
      end
    else
      final_expiration_date = self.expiration_date
    end

    self.update_attributes!(classes_left: final_classes_left, expiration_date: final_expiration_date, linked: true)

  end
  
  # Remote methods   
 
  def remote_login is_being_updated = false

    remote_user_session_path = "http://#{ENV['REMOTE_HOST']}/auth/sign_in"
    crypt = ActiveSupport::MessageEncryptor.new(ENV['SYNCH_KEY'])
    decrypted_password = crypt.decrypt_and_verify(self.u_password)
    
    user_params = { 'user[email]' => self.email, 'user[password]' => decrypted_password, 'is_being_updated' => is_being_updated }
    return Connection.post remote_user_session_path, user_params

  end

  def self.remote_authenticate email, password
    
    remote_user_session_path = "http://#{ENV['REMOTE_HOST']}/auth/sign_in"
    user_params = { 'user[email]' => email, 'user[password]' => password }
    return Connection.post remote_user_session_path, user_params

  end 

  def self.remote_validate_email email, headers 

    remote_validate_email_path = "http://#{ENV['REMOTE_HOST']}/users/validate_email"
    user_params = { 'email' => email }
    return Connection.post_with_headers remote_validate_email_path, user_params, headers 
    
  end 

  def self.remote_update_account email, password, headers
    
    remote_update_account_path = "http://#{ENV['REMOTE_HOST']}/users/update_account"
    user_params = { 'email' => email, 'password' => password }
    return Connection.post_with_headers remote_update_account_path, user_params, headers 

  end

  def remote_login_and_set_headers is_being_updated = false

    if self.headers 
      expiry_time = Time.at(self.headers["expiry"].to_i)
      #Close to expire
      if expiry_time <= (Time.zone.now + 1.hour)
        # Get new headers
        response = self.remote_login is_being_updated 
        self.headers = Connection.get_headers response
        self.save!
        return response
      end
    else 
      #Get new headers
      response = self.remote_login is_being_updated
      self.headers = Connection.get_headers response
      self.save!
      return response
    end
    return nil

  end

  def set_headers headers
    self.headers = headers
    self.save!
  end

  # N-bici unique methods

  def self.remote_request_classes_left headers

    remote_send_classes_left_path = "http://#{ENV['REMOTE_HOST']}/users/send_classes_left"
    return Connection.get_with_headers remote_send_classes_left_path, headers

  end

  private 

    def assign_coupon
      self.coupon = Discount.generate_coupon
    end

    def check_staff
      if self.staff?
        self.credits = 0.0
      end
    end
 
end
