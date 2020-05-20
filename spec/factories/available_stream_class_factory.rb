FactoryGirl.define do

  factory :available_streaming_class, class: AvailableStreamingClass do
    start Time.zone.now
    association :instructor, factory: :instructor
    association :stream_class, factory: :stream_class
  end

end
