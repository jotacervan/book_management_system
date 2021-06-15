FactoryBot.define do
  factory :user do
    name { 'Reader Boy' }
    email { 'reader_boy@email.com.br' }
    password { '123456' }
    password_confirmation { '123456' } 
  end
end
