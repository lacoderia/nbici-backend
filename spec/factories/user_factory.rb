FactoryGirl.define do
  
  factory :user, class: User do
    sequence(:email){ |n| "user-#{n}@iuvare.mx" }
    first_name 'Test'
    last_name 'User'
    password '12345678'
    roles {[FactoryGirl.create(:role)]}
  end

end
