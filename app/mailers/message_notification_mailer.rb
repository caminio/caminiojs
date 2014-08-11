class MessageNotificationMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def create_notification(user, item)
    @message = item
    @user = user
    @creator = User.find_by(item.created_by)
    @link = "dummy" # TODO
    I18n.with_locale(@user.locale) do
      mail to: user.email, subject: @message.title
    end
  end

end
