class Coupon

  DELSTRS = "0OB81I"

  def self.generate
    random = SecureRandom.hex
    coupon = (random.upcase.delete DELSTRS)[0..5]
    if not User.find_by_coupon(coupon)
      return coupon
    end
  end

  def is_valid?
    return User.find_by_coupon(coupon)
  end

end
