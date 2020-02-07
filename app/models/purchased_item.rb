class PurchasedItem < ActiveRecord::Base
  belongs_to :menu_purchase
  belongs_to :menu_item
end
