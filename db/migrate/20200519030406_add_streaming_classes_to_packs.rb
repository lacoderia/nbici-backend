class AddStreamingClassesToPacks < ActiveRecord::Migration
  def change
    add_column :packs, :streaming_classes, :integer
  end
end
