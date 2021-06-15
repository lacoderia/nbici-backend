class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :classes_left, :streaming_classes_left, :last_class_purchased, :picture, :uid, :active, :phone, :coupon, :coupon_value, :credits, :test, :linked, :expiration_date, :reference_class_cost

  def coupon_value
    Configuration.coupon_discount
  end

  def reference_class_cost
    Configuration.reference_class_cost
  end
end
