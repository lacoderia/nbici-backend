class PackSerializer < ActiveModel::Serializer

  attributes :id, :description, :classes, :streaming_classes, :price, :special_price, :active, :expiration, :force_special_price

  def force_special_price
    Configuration.force_special_price?
  end

end
