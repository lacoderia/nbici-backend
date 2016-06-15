class AddExpirationDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expiration_date, :datetime
    User.create_expiration_date_for_users_with_purchases
  end
end
