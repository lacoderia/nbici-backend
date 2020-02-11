class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.integer :menu_category_id
      t.float :price
      t.boolean :active, :default => true

      t.timestamps null: false
    end
  end
end
