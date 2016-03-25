FactoryGirl.define do
  factory :role, class: Role do
    name 'user'
  end

  factory :role_admin, parent: :role do
    name 'admin'
  end
  
end

