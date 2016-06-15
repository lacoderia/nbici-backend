class AddExpirationDateToUsers < ActiveRecord::Migration
  def up
    add_column :users, :expiration_date, :datetime
    User.create_expiration_date_for_users_with_purchases
  end

  def down
    remove_column :users, :expiration_date
  end
end
