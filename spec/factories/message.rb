FactoryGirl.define do

  factory :message do
    title "Message title"
    content "Message content\nWith paragraphs but no formats"
    creator
  end

end
