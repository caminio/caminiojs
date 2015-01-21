# template.rb
route "get '/caminio' => 'caminio_main#index'"

environment <<-EOS

    config.site.name = 'caminio'

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options, :put, :delete]
      end
    end 

EOS

gem 'caminio', github: 'caminio/caminio'
gem 'ember-source', '1.9.1'
gem 'ember-data-source', '1.0.0.beta.14.1'
gem 'rack-cors', :require => 'rack/cors'

gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''
gsub_file "Gemfile", /^gem\s+["']jquery-rails["'].*$/,''
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''
gsub_file "Gemfile", /^  gem\s+["']byebug["'].*$/,''
gsub_file "Gemfile", /^  gem\s+["']spring["'].*$/,''
gsub_file "Gemfile", /^  gem\s+["']web-console["'].*$/,'# was web-console'

file 'config/mongoid.yml', <<-CODE
production:
  sessions:
    default:
      hosts:
        - localhost:27017
      database: caminio
  options:
    include_root_in_json: true
    include_type_for_serialization: true
    scope_overwrite_exception: true
    raise_not_found_error: false
    use_activesupport_time_zone: false
    use_utc: true
development:
  sessions:
    default:
      hosts:
        - localhost:27017
      database: caminio-v2
  options:
    include_root_in_json: true
    include_type_for_serialization: true
    preload_models: true
    scope_overwrite_exception: true
    raise_not_found_error: false
    use_activesupport_time_zone: false
    use_utc: true
CODE

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
