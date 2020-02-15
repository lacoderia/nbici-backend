class AddScheduleToMenuPurchases < ActiveRecord::Migration
  def change
    add_column :menu_purchases, :schedule_id, :integer
  end
end
