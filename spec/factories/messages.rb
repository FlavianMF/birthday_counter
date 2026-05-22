FactoryBot.define do
  factory :message do
    association :event
    association :sender, factory: :user
    sender_name { sender&.name || "Anonymous" }
    content { "Happy Birthday!" }
    message_type { "text" }
    is_revealed { false }
  end
end
