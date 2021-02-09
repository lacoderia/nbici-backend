class AddStyleToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :style, :string
  end
end
