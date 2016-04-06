FactoryGirl.define do

  factory :card, class: Card do
    association :user, factory: :user
    uid "tok_test_visa_4242"
    object "card"
    active true
    last4 "4242"
    exp_month "12"
    exp_year "17"
    address "ADDRESS"
  end

end
