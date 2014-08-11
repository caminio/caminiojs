class AppSerializer < ActiveModel::Serializer
  attributes :id, :name, :hidden
  has_many :app_plans, embed: :ids
end
