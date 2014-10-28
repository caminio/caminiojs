class AppSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :hidden, :icon, :url
  has_many :app_plans, embed: :ids, embed_in_root: true
end
