class Label
  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Versioning
  include Mongoid::Paranoia

  include Caminio::UserStamps
  include Caminio::AccessRules

  field :name, type: String
  field :title, type: String, localize: true
  field :description, type: String, localize: true
  field :fgcolor, type: String
  field :bgcolor, type: String
  field :bdcolor, type: String

  embeds_many :activities

  after_destroy :delete_dependencies

  private

  def delete_dependencies
    Contact.where(label_ids: id).each{ |c| c.labels.delete(self) }
  end

end
