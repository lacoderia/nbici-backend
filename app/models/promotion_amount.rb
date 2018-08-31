class PromotionAmount < ActiveRecord::Base

  belongs_to :promotion
  belongs_to :pack
  
end
