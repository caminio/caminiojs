class Label < ActiveRecord::Base

  has_many :children, through: :row_labels
  has_many :row_labels, as: :row

  has_access_rules

end
