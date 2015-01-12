FactoryGirl.define do
  factory :user, class: 'User' do
    firstname "John"
    lastname  "Doe"
    username "johndoe"
    email "john.doe@example.com"
    password "johndoe"

    to_create { |instance| instance.save }

  end
end
