class Mediafile
  include Mongoid::Document
  include Mongoid::Userstamp
  include Mongoid::Versioning
  include Mongoid::Paranoia

  include Caminio::UserStamps
  include Caminio::AccessRules

  include Mongoid::Paperclip

  has_mongoid_attached_file :file,
    # path:         ':file/:id/:style.:extension',
    styles: {
      original: ['1920x1680>'],
      thumb: ['100x100#']
    }

  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  field :category, type: String

  field :parent_id, type: BSON::ObjectId
  field :parent_type, type: String

  def file_thumb
    file.url(:thumb)
  end
  def file_original
    file.url(:original)
  end

  def parent
    return unless parent_type && parent_id
    parent_type.constantize.find(parent_id)
  end

  def parent=(parent)
    self.parent_type = parent.class.name
    self.parent_id = parent.id
  end

end
