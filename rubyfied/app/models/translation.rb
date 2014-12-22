class Translation
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :meta_keywords, type: String
  field :meta_description, type: String
  field :aside, type: String
end
