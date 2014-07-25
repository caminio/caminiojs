class AppModel < ActiveRecord::Base
  belongs_to :app

  has_many :app_model_user_roles, dependent: :delete_all
  has_many :users, through: :app_model_user_roles
  
  validates_presence_of :name, :path, :icon
  validates_uniqueness_of :name, :path
end
