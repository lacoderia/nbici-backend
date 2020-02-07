class CreateMenuCategories < ActiveRecord::Migration
  def change
    create_table :menu_categories do |t|
      t.string :name
      t.string :image_url

      t.timestamps null: false
    end
  end
end
