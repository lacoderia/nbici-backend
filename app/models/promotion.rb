class Promotion < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :promotion_amounts, dependent: :delete_all
  has_many :packs, through: :promotion_amounts  
  has_many :purchases
  
  accepts_nested_attributes_for :promotion_amounts, allow_destroy: true
  
  before_save :capitalize_coupon

  
  def promotion_amounts_per_pack_id

    result = {}

    self.promotion_amounts.each do |promotion_amount|
      result[promotion_amount.pack.id] = promotion_amount.amount
    end

    return result
  
  end

  private

    def capitalize_coupon
      self.coupon = self.coupon.upcase
    end

end
