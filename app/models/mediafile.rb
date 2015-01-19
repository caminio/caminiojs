class Mediafile
  include Mongoid::Document
  include Caminio::Timestamps
  include Caminio::Userstamps

  include Mongoid::Paperclip

  @@default_thumb_sizes = { 
    original: ['1920x1680>']
  }

  has_mongoid_attached_file :file,
    path:         ':file/:id/:style.:extension',
    :styles => lambda { |attachment| 
      organization = Organization.find RequestStore.store['organization_id']
      { :thumb => ["100x100#"] }.merge organization.thumb_sizes || @@default_thumb_sizes 
    }


  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  field :category, type: String
  field :description, type: String
  field :copyright, type: String

  field :parent_id, type: BSON::ObjectId
  field :parent_type, type: String
  field :is_public, type: Boolean, default: true

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