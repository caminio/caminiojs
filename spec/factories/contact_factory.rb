FactoryGirl.define do
  factory :contact, class: 'Contact' do
    firstname "John"
    lastname  "Doe"
    email "john.doe@example.com"

    to_create { |instance| instance.save }

  end
end
