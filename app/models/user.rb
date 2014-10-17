require 'securerandom'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include Mongoid::Paperclip

  field :username, type: String
  field :firstname, type: String
  field :lastname, type: String
  field :email, type: String
  field :phone, type: String
  field :locale, type: String, default: I18n.locale
  field :description, type: String
  field :last_login_at, type: DateTime
  field :last_request_at, type: DateTime
  field :last_login_ip, type: String

  field :password_digest, type: String

  field :confirmation_key, type: String
  field :confirmation_key_expires_at, type: DateTime

  field :public_key, type: String
  field :private_key, type: String

  field :street, type: String
  field :zip, type: String
  field :country, type: String
  field :county, type: String
  field :city, type: String

  field :api_user, type: Boolean
  field :expires_at, type: DateTime

  has_and_belongs_to_many :organizational_units
  has_many :api_keys
  embeds_many :user_access_rules

  has_secure_password
  has_mongoid_attached_file :avatar,
    styles: {
      original: ['500x500>'],
      thumb: ['100x100#']
    }

  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  validates_presence_of :password, :on => :create  
  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email
  validates_format_of :email, :with => /@/

  after_create :find_or_create_organizational_unit 

  attr_accessor :current_organizational_unit
  attr_accessor :organizational_unit_name

  def gen_confirmation_key
    self.confirmation_key = SecureRandom.hex 
    self.confirmation_key_expires_at = 7.days.from_now
    confirmation_key
  end

  def gen_confirmation_key!
    gen_confirmation_key
    save!
  end

  def name
    return self.email unless self.lastname
    return self.lastname unless self.firstname
    return self.firstname + ' ' + self.lastname
  end

  private

  def avatar_thumb
    avatar.url(:thumb)
  end

  def find_or_create_organizational_unit 
    return organizational_units.first if organizational_units.where(name: 'private').first
    ou = OrganizationalUnit.create name: 'private'
    ou.users << self
    ou.save
    ou
  end

end
