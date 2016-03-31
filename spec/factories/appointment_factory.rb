FactoryGirl.define do

  factory :appointment, class: Appointment do
    association :user, factory: :user
    status "BOOKED"
    association :schedule, factory: :schedule
    bicycle_number 4
    start Time.zone.now
    description "Buena clase"
  end

end
