FactoryBot.define do
  factory :invoice_item do
    association :invoice, factory: :invoice
    association :item, factory: :item

    quantity { 1 }
    unit_price { 1 }

  end
end
