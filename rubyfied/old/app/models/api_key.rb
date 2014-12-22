require 'securerandom'

module Caminio

  class ApiKey < ActiveRecord::Base

    belongs_to :user

    before_create :generate_token, :generate_expiration_date

    private

    def generate_expiration_date
      self.expires_at = 8.hours.from_now
    end

    def generate_token
      self.token = SecureRandom.hex.to_s
    end
  end

end
