if Rails.env == 'production'
  Rails.logger = Logger.new(Rails.root.join("log/caminio.log"))
else
  Rails.logger = Logger.new(STDOUT)
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
