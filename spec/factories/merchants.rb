FactoryBot.define do
  factory :merchant do
    name { Faker::Dog.name + " " + Faker::Company.industry }
  end
end
