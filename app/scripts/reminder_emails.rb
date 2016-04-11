#!/usr/bin/env ruby
require_relative "../../config/environment"

# classes_left_reminder
def get_users_with_one_class_left
  #Gets users with 1 class left and that have no classes_left_remider emails, or that it has a reminder email but sent more than a week ago
  User.joins(:emails).where("classes_left = ? AND ((emails.email_type != ? AND emails.email_status = ?) OR (emails.email_type = ? AND emails.email_status = ? AND emails.created_at < ?))", 1, "classes_left_reminder", "sent", "classes_left_reminder", "sent", Time.zone.now - 7.days).group(:id)
end

# expiration_reminder
def get_users_with_expiring_classes
  #TODO: create the logic inside the SQL query
  #Gets users with purchases and that have no expiration_reminder emails, or that it has a reminder email but sent more than a week ago
  users_query = User.joins(:emails, :purchases => :pack).where("last_class_purchased < ? AND ((email.email_type != ? AND emails.email_status = ?) OR (emails.email_type = ? AND emails.email_status = ? AND emails.created_at <  ? )", Time.zone.now, "expiration_reminder", "sent", "expriation_reminder", "sent", Time.zone.now - 7.days).group(:id)
  #Traverse the user array to get the ones that satisfy the next condition
  users = []
  users_query.each |user| do
    last_purchase_expiration_days = user.purchases.last.pack.expiration    
    if user.last_class_purchased <= (Time.zone.now - last_purchase_expiration_days.days)
      users << user
    end
    users
  end
  
end
