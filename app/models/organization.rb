class Organization

  include Mongoid::Document
  include Caminio::Userstamps
  include Caminio::Timestamps

  field :name, type: String
  field :fqdn, type: String
  field :settings, type: Object
  field :suspended, type: Boolean, default: false
  
  has_and_belongs_to_many :users
  # has_and_belongs_to_many :app_plans

  # embeds_many :access_rules

  # after_save :check_owner_has_full_access
  before_create :setup_fqdn
  after_create :set_user_organization_role

  def access_for_user( user )
    return unless users.find(user.id)
    access_rules.where(user: user).first
  end

  def apps
    app_plans.map(&:app)
  end

  private

  def setup_fqdn
    return unless fqdn.blank?
    self.fqdn = "#{name.gsub(' ','_').underscore}.camin.io"
  end

  def check_owner_has_full_access
    return unless owner = users.first
    app_plans.each do |plan|
      access_rules.find_or_create_by( user: owner, can_write: true, can_share: true, can_delete: true, app: plan.app )
    end
  end

  def set_user_organization_role
    owner = users.first
    owner.organization_roles.create organization: self, admin: true, editor: true
    owner.save
  end

end
