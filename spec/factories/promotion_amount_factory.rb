FactoryGirl.define do

  factory :promotion_amount, class: PromotionAmount do

    amount 100.00
    association :promotion, factory: :promotion
    association :pack, factory: :pack

  end

end
