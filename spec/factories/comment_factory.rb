FactoryGirl.define do
  factory :comment, class: 'Comment' do
    title "comment title"
    content "comment description"

    to_create { |instance| instance.save }

  end
end
