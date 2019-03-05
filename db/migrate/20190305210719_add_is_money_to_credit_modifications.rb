class AddIsMoneyToCreditModifications < ActiveRecord::Migration
  def change
    add_column :credit_modifications, :is_money, :boolean, default: false
  end
end
