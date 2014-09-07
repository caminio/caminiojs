class TranslationSerializer < ActiveModel::Serializer
  attributes :id, :content, :title, :subtitle, :aside, :aside2, :aside3, :description, :keywords, :created_by, :created_at, :updated_by, :updated_at, :row_id, :row_type, :locale
end
