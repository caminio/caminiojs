Rails.application.routes.draw do


  mount Caminio::V1::Root              => '/'

  get '/activities/:user_id/:organization_id' => 'activities#index'

  mount GrapeSwaggerRails::Engine => '/swagger' unless Rails.env.test? || Rails.env.ticket_app?

end
