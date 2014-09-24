class Activity
  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Timestamps

  field :category, type: String
  field :content, type: String

end
