class OrganizationalUnit

  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Timestamps

  field :name, type: String
  field :suspended, type: Boolean, default: false
  field :name, type: String
  
  belongs_to :owner, class_name: 'User', inversive_of: :organizational_unit

      t.string        :name
      t.integer       :owner_id
      t.boolean       :suspended
      t.string        :color
      t.text          :settings
      t.integer       :created_by
      t.integer       :updated_by
      t.timestamps
  serialize   :settings, JSON
  has_many    :users, through: :organizational_unit_members
  has_many    :app_plans, -> { distinct }, through: :organizational_unit_app_plans
  has_many    :organizational_unit_members
  has_many    :organizational_unit_app_plans
  has_many    :app_model_user_roles
  belongs_to  :owner, class_name: 'User'
  
  def link_apps(apps)
    apps.each_pair do |app_plan, value|
      if value
        OrganizationalUnitAppPlan.create( 
          :app_plan_id => app_plan, 
          :organizational_unit => self 
        )
      end
    end
  end
    
end
