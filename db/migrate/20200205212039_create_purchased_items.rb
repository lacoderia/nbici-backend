class CreatePurchasedItems < ActiveRecord::Migration
  def change
    create_table :purchased_items do |t|
      t.references :menu_purchase, index: true, foreign_key: true
      t.references :menu_item, index: true, foreign_key: true
      t.integer :amount

      t.timestamps null: false
    end
  end
end
