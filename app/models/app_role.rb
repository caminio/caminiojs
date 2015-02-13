class AppRole

  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps

  embedded_in :user
  
  field :app_name, type: String
  field :rights, type: String, default: 'r'

end