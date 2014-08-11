class AppSerializer < ActiveModel::Serializer
  attributes :id, :name, :hidden, :icon, :add_js, :path
  has_many :app_plans, embed: :ids
end
