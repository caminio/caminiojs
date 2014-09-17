class Label < ActiveRecord::Base

  has_many :children, through: :row_labels
  has_many :row_labels, as: :row, dependent: :delete_all

  has_access_rules app_name: "caminio", hidden: true

end
