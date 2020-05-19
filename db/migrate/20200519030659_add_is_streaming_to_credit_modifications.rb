class AddIsStreamingToCreditModifications < ActiveRecord::Migration
  def change
    add_column :credit_modifications, :is_streaming, :boolean, default: false
  end
end
