class AddTestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :test, :boolean, default: false
  end
end
