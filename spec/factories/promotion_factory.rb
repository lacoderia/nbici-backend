FactoryGirl.define do

  factory :promotion, class: Promotion do

    coupon "NBICI"
    description "test coupon"
    active true

    trait :inactive do
      coupon "NBICI_INACTIVE"
      active false
    end
    
  end

end
