FactoryBot.define do
  factory :transaction do
    association :book 
    association :user
    start_date { "2021-06-15" }
    end_date { "2021-06-25" }
  end
end
