class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :coupon, :description, :active#, :amount
end
