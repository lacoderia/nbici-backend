class Configuration < ActiveRecord::Base

  DEFAULT_DISCOUNT_AMOUNT = 40.00
  DEFAULT_REFERRAL_CREDIT = 40.00

  def self.coupon_discount
    coupon_discount = Configuration.find_by_key("coupon_discount")
    if coupon_discount
      return coupon_discount.value.to_f
    else
      return DEFAULT_DISCOUNT_AMOUNT
    end
  end

  def self.referral_credit
    referral_credit = Configuration.find_by_key("referral_credit")
    if referral_credit
      return referral_credit.value.to_f
    else
      return DEFAULT_REFERRAL_CREDIT
    end
  end

end
