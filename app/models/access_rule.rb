class AccessRule < ActiveRecord::Base
  belongs_to :row, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: :created_by
  belongs_to :updater, class_name: 'User', foreign_key: :updated_by
  belongs_to :label
end
