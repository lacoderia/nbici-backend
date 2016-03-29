FactoryGirl.define do

  factory :schedule, class: Schedule do
    datetime Time.zone.now
    association :room, factory: :room
    association :instructor, factory: :instructor
  end

end
