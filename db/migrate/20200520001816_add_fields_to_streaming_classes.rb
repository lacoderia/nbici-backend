class AddFieldsToStreamingClasses < ActiveRecord::Migration
  def change
    add_column :streaming_classes, :intensity, :integer
    add_column :streaming_classes, :title, :string
  end
end
