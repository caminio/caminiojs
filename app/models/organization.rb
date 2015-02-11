class Organization

  include Mongoid::Document
  include Caminio::Userstamps
  include Caminio::Timestamps

  field :name, type: String
  field :fqdn, type: String
  field :settings, type: Object
  field :suspended, type: Boolean, default: false
  field :thumb_sizes, type: Hash, default: {}
  field :user_quota, type: Integer, default: 1
  
  has_and_belongs_to_many :users
  embeds_many :app_plans

  before_create :setup_fqdn
  after_create :set_user_organization_role

  def access_for_user( user )
    return unless users.find(user.id)
    access_rules.where(user: user).first
  end

  private

  def setup_fqdn
    return unless fqdn.blank?
    self.fqdn = "#{name.gsub(' ','_').underscore}.camin.io"
  end

  def set_user_organization_role
    owner = users.first
    owner.organization_roles.create organization: self, name: 'admin'
    owner.save
  end

end