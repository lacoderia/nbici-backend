class AddExpirationDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expiration_date, :datetime
    
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
end
