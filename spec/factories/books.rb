FactoryBot.define do
  factory :book do
    name { "My Book" }
    description { "Some description about the book" }
    image_url { "http://image_url" }
  end
end
