FactoryGirl.define do
  
  factory :configuration, class: Configuration do

    trait :coupon_discount do
      key "coupon_discount"
      value "40"
    end

  end

end
