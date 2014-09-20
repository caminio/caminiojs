class ApiKey
  include Mongoid::Document

  field :access_token, type: String
  field :expires_at, type: DateTime

  belongs_to :user
  
  before_create :setup_access_token, :setup_expires_at

  private

  def setup_access_token
    self.access_token = SecureRandom.hex(64)
    setup_access_token if self.class.where( access_token: self.access_token ).first
  end

  def setup_expires_at
    self.expires_at = 8.hours.from_now
  end

end
