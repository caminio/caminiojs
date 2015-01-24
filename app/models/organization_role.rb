class OrganizationRole
  include Mongoid::Document
  
  embedded_in :user
  belongs_to :organization

  field :name, type: String, default: 'default'

  def admin?
    name == 'admin'
  end

  def editor?
    %w(editor admin).include? name
  end

end
