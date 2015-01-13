Dir.glob( File.expand_path("../../../app/helpers", __FILE__)+'/**/*.rb' ).each do |file|
  require file
end