class AccessRule < ActiveRecord::Base
  belongs_to :row, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: :created_by
  belongs_to :updater, class_name: 'User', foreign_key: :updated_by
  belongs_to :organizational_unit
  belongs_to :user
  belongs_to :label

  before_destroy :check_rights
  # before_update :check_rights

  def with_user(user)
    puts "IS CALLED"
    @current_user = user
  end

  private

    def check_rights
      puts "checking"
      puts @current_user.inspect
      raise err unless @current_user
      return if @current_user.id == creator_id 
      return if @current_user.id == updater_id
      raise err unless @current_user.id == organizational_unit.owner_id
    end

    def err
      StandardError.new("Insufficient rights")
    end

end
