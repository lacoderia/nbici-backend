FactoryGirl.define do

  factory :distribution, class: Distribution do
    height 2
    width 2
    description "Cuadradito"
    inactive_seats "[]"
    active_seats "[1,2,3,4]"
    total_seats 4
  end

end
