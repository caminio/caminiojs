unless ( File.basename($0) == 'rake')
  if Rails.env == 'production'
    Rails.logger = Logger.new(Rails.root.join("log/caminio.log"))
  elsif Rails.env == 'development'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Rails.logger = Logger.new(STDOUT)
  end
end
