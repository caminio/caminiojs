class MessageNotificationMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def create_notification(user, item)
    @message = item
    @user = user
    @creator = User.find_by(item.created_by)
    @link = "dummy"
    # mail to: user.email
  end

end
