FactoryGirl.define do

  factory :streaming_class, class: StreamingClass do
    title "Test Stream Class"
    description "Test Description"
    length "30 minutos"
    intensity 2
    photo { File.new("#{Rails.root}/spec/support/images/image.png") }   
    insertion_code "<script></script>"
    association :instructor, factory: :instructor

    trait :inactive do
      active false
    end

  end

end
