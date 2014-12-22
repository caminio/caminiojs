module Caminio
  def self.env
    ENV['RACK_ENV'] || 'development'
  end
end
