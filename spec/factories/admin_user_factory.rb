FactoryGirl.define do

  factory :admin_user, class: AdminUser do
    sequence(:email){ |n| "admin-#{n}@nbici.com" }
    password "password"
    password_confirmation "password"
  end

end
