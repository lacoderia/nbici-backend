class PromotionAmountSerializer < ActiveModel::Serializer
  attributes :id, :promotion_id, :pack_id, :amount
end
