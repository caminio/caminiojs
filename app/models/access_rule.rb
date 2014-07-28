class AccessRule < ActiveRecord::Base
  belongs_to :row, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: :created_by
  belongs_to :updater, class_name: 'User', foreign_key: :updated_by
  belongs_to :organizational_unit
  belongs_to :user
  belongs_to :label

  before_destroy :check_if_destroyer_has_rights

  private

    def check_if_destroyer_has_rights
      raise StandardError.new("Insufficient rights") unless is_owner || can_delete
    end

end
