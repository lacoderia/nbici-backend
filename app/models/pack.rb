class Pack < ActiveRecord::Base
  has_many :purchases
  has_many :promotion_amounts
  has_many :promotions, through: :promotion_amounts

  scope :active, -> {where(active: true)}
  
  def price_or_special_price_for_user user  

    if Configuration.force_special_price?

      if self.special_price
        return self.special_price
      else
        return self.price
      end

    else

      if user.purchases.empty?
        if self.special_price
          return self.special_price
        else
          return self.price
        end
      else
        return self.price
      end
      
    end
    
  end

  def price_with_credits_for_user user

    pack_price = self.price_or_special_price_for_user user
    final_price = pack_price
    final_credits = user.credits
    
    if final_credits > 0.0
      if final_credits > final_price
        final_price = 0.0
        final_credits = final_credits - pack_price 
      else
        final_price = final_price - final_credits
        final_credits = 0.0
      end
    end

    return {final_price: final_price, initial_price: pack_price, final_credits: final_credits, initial_credits: user.credits}
  end

  def price_with_coupon_for_user user, meta_coupon 

    pack_price = self.price_or_special_price_for_user user
    final_price = pack_price

    if meta_coupon[:type].eql? Discount::USER_COUPON_TYPE
    
      final_price -= meta_coupon[:value]

    elsif meta_coupon[:type].eql? Discount::PROMOTION_COUPON_TYPE 

      final_price -= meta_coupon[:value][self.id] if meta_coupon[:value][self.id]

    end

    discount = meta_coupon[:value]
    if final_price < 0
      final_price = 0
      discount = pack_price
    end
    return {final_price: final_price, initial_price: pack_price, coupon: meta_coupon[:coupon], discount: discount} 
    
  end
  
end
