FactoryGirl.define do

  factory :user do
    firstname "John"
    lastname "Doe"
    username "john"
    # password "johN123"
    # password_confirmation { |u| u.password }
  end

end
