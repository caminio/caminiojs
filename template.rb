# template.rb
route "'/caminio' => 'caminio_main#index"

environment <<-EOS

    config.caminio.site.name = 'caminio'

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options, :put, :delete]
      end
    end 
    
EOS

rake("db:migrate")

gem 'caminio', github: 'caminio/caminio'
gem 'ember-source', '1.9.1'
gem 'ember-data-source', '1.0.0.beta.14.1'
gem 'rack-cors', :require => 'rack/cors'

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end