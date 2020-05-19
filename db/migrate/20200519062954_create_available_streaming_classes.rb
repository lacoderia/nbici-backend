class CreateAvailableStreamingClasses < ActiveRecord::Migration
  def change
    create_table :available_streaming_classes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :streaming_class, index: true, foreign_key: true
      t.datetime :start

      t.timestamps null: false
    end
  end
end
