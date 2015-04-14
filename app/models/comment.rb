class Comment
  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps

  embedded_in :commentable, polymorphic: true

  field :title, type: String, localize: true
  field :content, type: String, localize: true

end
