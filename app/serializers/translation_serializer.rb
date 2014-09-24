class TranslationSerializer < ActiveModel::Serializer
  attributes :id, :content, :title, :subtitle, :aside, :aside2, :aside3, :description, :keywords
end
