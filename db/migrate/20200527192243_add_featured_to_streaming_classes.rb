class AddFeaturedToStreamingClasses < ActiveRecord::Migration
  def change
    add_column :streaming_classes, :featured, :boolean, default: false
  end
end
