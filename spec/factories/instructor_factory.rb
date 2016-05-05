FactoryGirl.define do

  factory :instructor, class: Instructor do
    first_name 'Morenazo'
    last_name "Nazo"
    picture "picture_url"
    quote "Hola"
    bio "Soy buenísimo"
    association :admin_user, factory: :admin_user
  end

end
