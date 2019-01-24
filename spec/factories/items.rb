FactoryBot.define do
  factory :item do
    name { Faker::Vehicle.make_and_model }
    description { Faker::Vehicle.drive_type + " " + Faker::Vehicle.transmission + " " + Faker::Vehicle.fuel_type + " " + "vehicle" }
    unit_price { Faker::Number.between(1000, 99999) }
    association :merchant, factory: :merchant
  end
end
