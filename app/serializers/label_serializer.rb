class LabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :fgcolor, :bgcolor, :bdcolor, :category
end
