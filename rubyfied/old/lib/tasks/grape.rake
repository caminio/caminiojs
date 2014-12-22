desc "API Routes"
task :routes do
  require 'caminio/Accounts'
  Caminio::Accounts::init
  Caminio::Accounts::API::Root.routes.each do |api|
    method = api.route_method.ljust(10)
    path = api.route_path
    puts "     #{method} #{path}"
  end
end
