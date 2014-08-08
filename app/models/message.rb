class Message < ActiveRecord::Base


  has_access_rules(icon: "fa-envelope-o", path: "/messages", app_name: "caminio", app_is_public: true)
  can_notify( :notification_mailer => MessageNotificationMailer )

  belongs_to :row, polymorphic: true
  belongs_to :organizational_unit
  belongs_to :parent, class_name: 'Message'

  has_many :users, through: :user_messages
  has_many :user_messages
  has_many :children, class_name: 'Message', foreign_key: :parent_id

  after_create :create_user_messages, :notify_on_create

  def attributes
    { title: nil,
      content: nil,
      parent_id: nil,
      type: nil,
      row_id: nil,
      row_type: nil,
      id: nil
    }
  end

  private

    def create_user_messages
      UserMessage.create( :user => self.creator, :message => self, :read => true )
      all_users = self.users
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
