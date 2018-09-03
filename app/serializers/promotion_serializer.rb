class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :coupon, :description, :active, :promotion_amounts
end
