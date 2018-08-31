class CreatePromotionAmounts < ActiveRecord::Migration
  def change
    create_table :promotion_amounts do |t|

      t.integer :promotion_id
      t.integer :pack_id
      t.float :amount

      t.timestamps null: false
    end
    add_index :promotion_amounts, [:promotion_id, :pack_id], :unique => true
  end
end
