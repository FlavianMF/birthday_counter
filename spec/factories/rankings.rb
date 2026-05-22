FactoryBot.define do
  factory :ranking do
    association :event
    association :user
    total_score { 0 }
    coins { 0 }
    streak_days { 0 }
  end
end
