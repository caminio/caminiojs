class AppModel < ActiveRecord::Base
  belongs_to :app
  validates_presence_of :name, :path, :icon
  validates_uniqueness_of :name, :path
end
