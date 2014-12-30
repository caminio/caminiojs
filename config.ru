require 'caminio'
require 'rack/cors'
require 'request_store'

require 'active_record'
use ActiveRecord::ConnectionAdapters::ConnectionManagement

use RequestStore::Middleware

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [ :get, :post, :put, :delete, :options ]
  end
end

Caminio.init

map('/api') { run Caminio::API::Root }
