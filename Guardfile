guard 'puma', :port => 4000 do
  watch('Gemfile.lock')
  watch(%r{^app|lib|config/.*})
  notification :off
end
