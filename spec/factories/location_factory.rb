FactoryGirl.define do
  factory :location, class: 'Location' do
    title "a location"
    street  "elmstreet"
    city "minsk"
    state "sweden"

    to_create { |instance| instance.save }

  end
end
