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

gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''
gsub_file "Gemfile", /^gem\s+["']byebug["'].*$/,''
gsub_file "Gemfile", /^gem\s+["']spring["'].*$/,''
gsub_file "Gemfile", /^gem\s+["']web-console["'].*$/,'# was web-console'
gsub_file "Gemfile", /^gem\s+["']jquery-rails["'].*$/,''

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end