class AddStreamingClassesLeftToUsers < ActiveRecord::Migration
  def change
    add_column :users, :streaming_classes_left, :integer, default: 0
  end
end
