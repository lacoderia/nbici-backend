class RemoveAmountFromPromotions < ActiveRecord::Migration
  def change
    remove_column :promotions, :amount, :float
  end
end
