class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :classes_left, :last_class_purchased, :picture, :uid, :active, :phone, :coupon, :credits, :referrals_count

  def referrals_count
    object.referrals.count
  end

end
