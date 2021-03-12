#!/usr/bin/env ruby
require_relative "../config/environment"

CSV.open("export_expired_users.csv", "wb") do |csv|
  csv << ["Email", "Clases actuales", "Expiracion actual", "Ultimas clases compradas", "Expiracion de compra", "Ultima modificacion de creditos", "Expiracion de creditos"]

  users = User.where("classes_left > 0 AND expiration_date > ?", Time.zone.now)

  users.each do |user|

    last_purchases = user.purchases.where("pack_id IS NOT NULL").order(created_at: :desc)[0..2]
    last_classes_str = ""
    last_expiration_str = ""
    last_purchases.each do |purchase|
      last_classes_str += purchase.pack.description + "\n"
      last_expiration_str += (purchase.created_at + purchase.pack.expiration.days).strftime("%d/%m/%Y %I:%M%p") + "\n"
    end

    last_credit_modifications = user.credit_modifications.where("is_money = ? and is_streaming = ?", false, false).order(created_at: :desc)[0..2]
    last_cm_str = ""
    last_cm_expiration_str = ""
    last_credit_modifications.each do |cm|
      last_cm_str += cm.reason + "\n"
      if cm.pack_id
        if cm.pack.expiration
          last_cm_expiration_str += (cm.created_at + cm.pack.expiration.days).strftime("%d/%m/%Y %I:%M%p") + "\n"
        else
          last_cm_expiration_str += " \n"
        end
      else
        credits = cm.credits
        expiration = 0
        less_or_equal_to_zero = ->(x) { x <= 0 }

        case credits
            when less_or_equal_to_zero
              expiration = 0
            when 1..4
              expiration = 15
            when 5..9
              expiration = 30
            when 10..24
              expiration = 90
            when 25..49
              expiration = 180
            else
              expiration = 360
            end
        last_cm_expiration_str += (cm.created_at + expiration.days).strftime("%d/%m/%Y %I:%M%p") + "\n"
      end
    end

    user_txt = [user.email, user.classes_left, user.expiration_date.strftime("%d/%m/%Y %I:%M%p"), last_classes_str, last_expiration_str, last_cm_str, last_cm_expiration_str]
    csv << user_txt
  end

end
