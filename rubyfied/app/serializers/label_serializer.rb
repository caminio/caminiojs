class LabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :fgcolor, :bgcolor, :bdcolor, :category
  has_one :organizational_unit

  def organizational_unit
    object.access_rules.first.organizational_unit
  end
end
