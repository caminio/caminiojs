class OrganizationalUnit

  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Timestamps

  field :name, type: String
  field :suspended, type: Boolean, default: false
  field :name, type: String
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :app_plans

  embeds_many :access_rules

  after_save :check_owner_has_full_access

  def access_for_user( user )
    return unless users.find(user.id)
    access_rules.where(user: user).first
  end

  private

  def check_owner_has_full_access
    return unless owner = users.first
    app_plans.each do |plan|
      access_rules.find_or_create_by( user: owner, can_write: true, can_share: true, can_delete: true, app: plan.app )
    end
  end

end
