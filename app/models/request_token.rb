class RequestToken
  include Mongoid::Document
  include Caminio::Timestamps

  field :token, type: String
  field :expires_at, type: DateTime
  
  belongs_to :api_key
  before_create :setup_token, :setup_expires_at

  private

  def setup_token
    self.token = SecureRandom.hex
    setup_token if self.class.where( token: self.token ).first
  end

  def setup_expires_at
    self.expires_at = 1.hours.from_now
  end

end
