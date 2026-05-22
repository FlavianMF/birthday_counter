FactoryBot.define do
  factory :shop_item do
    name { "Emoji Rain" }
    cost { 500 }
    item_type { "effect" }
    effect_name { "emoji_rain" }
    duration_seconds { 600 }
  end
end
