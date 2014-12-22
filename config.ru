require 'caminio/accounts'
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

Caminio::Accounts.init

map('/api') { run Caminio::Accounts::API::Root }
