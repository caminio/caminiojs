class Message < ActiveRecord::Base


  has_access_rules app_name: "caminio", hidden: true

  can_notify notification_mailer: MessageNotificationMailer

  belongs_to :row, polymorphic: true
  belongs_to :organizational_unit
  belongs_to :parent, class_name: 'Message'

  has_many :users, through: :user_messages
  has_many :user_messages
  has_many :children, class_name: 'Message', foreign_key: :parent_id

  after_create :create_user_messages, :set_notification_users, :notify_on_create

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

    def set_notification_users
      puts "there"
      @notify_users = self.users
    end

end
