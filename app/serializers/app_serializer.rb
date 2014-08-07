class AppSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_public
  has_many :app_plans, embed: :ids
end
