class MenuItem < ActiveRecord::Base
  belongs_to :menu_category
  has_many :purchased_items  
  has_many :menu_purchases, :through => :purchased_items
  
  scope :active, -> {where(active: true)}
  
end
