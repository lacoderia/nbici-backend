class AddPriceToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :price, :float
  end
end
