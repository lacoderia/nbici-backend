class PromotionAmount < ActiveRecord::Base

  belongs_to :promotion
  belongs_to :pack
  
  validates_uniqueness_of :promotion_id, scope: :pack_id
end
