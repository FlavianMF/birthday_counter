FactoryBot.define do
  factory :event_participant do
    association :event
    association :user
    role { "guest" }
    has_accepted { true }
  end
end
