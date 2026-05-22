FactoryBot.define do
  factory :active_effect do
    association :event
    association :user
    association :shop_item
    activated_at { Time.current }
    active { true }
  end
end
