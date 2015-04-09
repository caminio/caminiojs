class Comment
  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps
  
  field :title, type: String, localize: true
  field :description, type: String, localize: true

end
