class Promotion < ActiveRecord::Base

  before_save :capitalize_coupon

  private

    def capitalize_coupon
      self.coupon = self.coupon.upcase
    end

end
