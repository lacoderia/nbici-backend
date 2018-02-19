class AddHeadersToUser < ActiveRecord::Migration
  def change
    add_column :users, :headers, :text
  end
end
