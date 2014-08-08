if Rails.env == 'production'
  Rails.logger = Logger.new(Rails.root.join("log/caminio.log"))
else
  if Rails.env == 'development'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
  Rails.logger = Logger.new(STDOUT)
end
