class Message < ActiveRecord::Base

  belongs_to :row, polymorphic: true
  belongs_to :organizational_unit
  belongs_to :parent, class_name: 'Message'

  has_many :users, through: :user_messages
  has_many :user_messages
  has_many :children, class_name: 'Message', foreign_key: :parent_id

  after_create :create_user_messages

  has_access_rules(icon: "fa-envelop-o", path: "/messages", app_name: "caminio")

  def attributes
    { title: nil,
      content: nil,
      followup_id: nil,
      id: nil
    }
  end

  private

    def create_user_messages
      all_users = self.users
      all_users.push( self.creator )
      if self.organizational_unit
        self.organizational_unit.users.each do |unit_user|
          all_users.push( unit_user ) unless all_users.include?( unit_user )
        end
      end
      
      all_users.each do |user|
        UserMessage.create( :user => user, :message => self )
      end
    end
end
