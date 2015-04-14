class Activity
  include Mongoid::Document

  field :name
  field :item_id
  field :item_type
  field :created_at, type: DateTime

  belongs_to :organization
  belongs_to :user
  belongs_to :activitable, polymorphic: true

  before_save :set_current_user_and_timestamps

  private

  def set_current_user_and_timestamps
    self.created_at = Time.now
    self.user_id = RequestStore::store['current_user_id']
    self.organization_id = RequestStore::store['organization_id']
  end

end