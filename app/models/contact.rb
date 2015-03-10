class Contact

  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps
  include Caminio::AccessRules

end



# class Contact

#   include Mongoid::Document
#   include Mongoid::Timestamps
#   include Mongoid::Userstamp
#   include Mongoid::Versioning
#   include Mongoid::Paranoia
#   include Caminio::AccessRules

#   field :firstname, type: String
#   field :lastname, type: String
#   field :email, type: String

#   embedds_many :locations

#   field :field_data, type: Hash
#   has_and_belongs_to_many :labels

# end
