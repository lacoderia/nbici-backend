FactoryGirl.define do

  factory :instructor, class: Instructor do
    first_name 'Morenazo'
    last_name "Nazo"
    email "morenazo@nazo.com"
    picture "picture_url"
    quote "Hola"
    bio "Soy buenísimo"
  end

end
