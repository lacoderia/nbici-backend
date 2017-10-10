class AddOpeningToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :opening, :boolean, default: false
  end
end
