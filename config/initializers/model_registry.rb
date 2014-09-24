# unless ( File.basename($0) == 'rake')
#   if Rails.env === 'development'
#     Dir.glob( File.expand_path("../../../app/models", __FILE__)+'/**/*.rb' ).each do |file|
#       require file
#     end
#   end
#   Caminio::ModelRegistry::init
# end
