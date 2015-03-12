FactoryGirl.define do
  factory :user, class: 'User' do
    firstname "John"
    lastname  "Doe"
    username "johndoe"
    email "john.doe@example.com"
    password "johndoe"

    to_create { |instance| instance.save }

    after(:build) do |model, evaluator|
      RequestStore.store['current_user_id'] = model.id
    end

    after(:create) do |model, evaluator|
      org = model.organizations.create( name: "an organization" )
      RequestStore.store['organization_id'] = org.id
    end

  end
end
