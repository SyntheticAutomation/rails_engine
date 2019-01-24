FactoryBot.define do
  factory :transaction do
    association :invoice, factory: :invoice
    credit_card_number { Faker::Stripe.valid_card }
    result { ["success", "failed"].sample }
  end
end
