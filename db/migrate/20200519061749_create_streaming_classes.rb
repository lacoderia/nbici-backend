class CreateStreamingClasses < ActiveRecord::Migration
  def change
    create_table :streaming_classes do |t|
      t.references :instructor, index: true, foreign_key: true
      t.string :description
      t.string :length
      t.text :insetion_code
      t.boolean :active

      t.timestamps null: false
    end
  end
end
