class AddLinkedAndUPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linked, :boolean, default: false
    add_column :users, :u_password, :string
  end
end
