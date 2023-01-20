FactoryBot.define do
  factory :event do
    association :user

    title { 'название' }
    address { 'адрес' }
    datetime { Time.now }
  end
end
