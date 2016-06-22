class Discount 

  DELSTRS = "0OB81I"

  def self.generate_coupon
    random = SecureRandom.hex
    coupon = (random.upcase.delete DELSTRS)[0..5]
    if not User.find_by_coupon(coupon)
      return coupon
    end
  end

  def self.exists? coupon
    if coupon
      return User.find_by_coupon(coupon) ? true : false
    else
      return false
    end
  end

  def self.validate_with_credits_and_pack_id current_user, pack_id
    if not pack = Pack.find_by_id(pack_id)
      raise "El paquete no existe."
    end

    self.validate_with_credits_and_pack current_user, pack
  end

  def self.validate_with_credits_and_pack current_user, pack
    return pack.price_with_credits_for_user current_user
  end

  def self.validate_with_coupon_and_pack_id current_user, pack_id, coupon
    if not pack = Pack.find_by_id(pack_id)
      raise "El paquete no existe."
    end 

    self.validate_with_coupon_and_pack current_user, pack, coupon
  end  

  def self.validate_with_coupon_and_pack current_user, pack, coupon

    if current_user.coupon == coupon
      raise "No puedes usar tu propio cupón."
    end

    if Referral.find_by_referred_id(current_user.id)
      raise "Ya has usado un cupón anteriormente."
    end
    
    if Discount.exists? coupon
      return pack.price_with_coupon_for_user current_user, coupon
    else
      raise "El cupón no existe."
    end
  end

end
