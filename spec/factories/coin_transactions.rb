FactoryBot.define do
  factory :coin_transaction do
    association :user
    association :event
    amount { 100 }
    transaction_type { "earned" }
    source { "game" }
  end
end
