FactoryGirl.define do
  factory :api_key, class: 'ApiKey' do
    name "a new api_key"
    permanent false

    to_create { |instance| instance.save }

  end
end
