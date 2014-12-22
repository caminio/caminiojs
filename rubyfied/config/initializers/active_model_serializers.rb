# config/initializers/active_model_serializers.rb
Mongoid::Document.send(:include, ActiveModel::SerializerSupport)
Mongoid::Criteria.delegate(:active_model_serializer, :to => :to_a)

ActiveModel::Serializer.setup do |config|
  config.embed = :ids
  config.embed_in_root = true                                               
end  

module BSON
  class ObjectId
    alias :to_json :to_s
    alias :as_json :to_s
  end
end
