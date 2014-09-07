Rails.application.routes.draw do
  mount Users::API => "/caminio/users"
  mount Translations::API => "/caminio/translations"
  mount AppPlans::API => "/caminio/app_plans"
  mount OrganizationalUnits::API => "/caminio/organizational_units"
  mount ApiKeys::API => "/caminio/api_keys"
  mount Sessions::API => "/caminio/sessions"
  get "/caminio" => "caminio/main#index"
end
