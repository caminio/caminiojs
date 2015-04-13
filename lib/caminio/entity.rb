Dir.glob( File.expand_path("../../../app/entities", __FILE__)+'/**/*.rb' ).each do |file|
  require file
end