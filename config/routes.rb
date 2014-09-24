Rails.application.routes.draw do
  mount Users::API => "/caminio/users"
  mount Translations::API => "/caminio/translations"
  mount Labels::API => "/caminio/labels"
  mount AppPlans::API => "/caminio/app_plans"
  mount Mediafiles::API => "/caminio/mediafiles"
  mount Apps::API => "/caminio/apps"
  mount OrganizationalUnits::API => "/caminio/organizational_units"
  mount ApiKeys::API => "/caminio/api_keys"
  mount Sessions::API => "/caminio/sessions"
  get "/caminio" => "caminio/main#index"
end
