class CreateMenuPurchases < ActiveRecord::Migration
  def change
    create_table :menu_purchases do |t|
      t.integer :appointment_id
      t.integer :user_id
      t.string :uid
      t.string :object
      t.boolean :livemode
      t.string :conekta_status
      t.string :description
      t.integer :amount
      t.string :currency
      t.text :payment_method
      t.text :details
      t.text :notes
      t.string :status

      t.timestamps null: false
    end
  end
end
