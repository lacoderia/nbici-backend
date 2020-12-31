class CreateWaitlists < ActiveRecord::Migration
  def change
    create_table :waitlists do |t|
      t.references :schedule, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end
