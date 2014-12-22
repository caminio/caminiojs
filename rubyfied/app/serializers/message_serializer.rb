class MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :content
end