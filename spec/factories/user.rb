FactoryGirl.define do

  require 'securerandom'

  factory :user, aliases: [:creator] do
    firstname "John"
    lastname "Doe"
    username "john"
    email { "john#{SecureRandom.hex(8)}@example.com" }
    password "johN123"
    password_confirmation { |u| u.password }
  end

end
