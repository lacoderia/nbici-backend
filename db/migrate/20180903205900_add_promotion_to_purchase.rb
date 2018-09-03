class AddPromotionToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :promotion_id, :integer
  end
end
