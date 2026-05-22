FactoryBot.define do
  factory :event do
    association :host, factory: :user
    name { "Birthday Party" }
    description { "Celebration event" }
    target_date { 1.day.from_now }
    status { "active" }
    is_surprise { false }
    config { {} }
  end
end
