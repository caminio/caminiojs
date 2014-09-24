class MediafileSerializer < ActiveModel::Serializer
  attributes :id, :file_file_name, :file_thumb, :file_original, :file_content_type, :file_file_size
end
