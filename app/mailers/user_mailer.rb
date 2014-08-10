class UserMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def reset_password(user, link)
    @user = user
    @link = link
    mail to: user.email, subject: I18n.t('caminio_password_reset')
  end

  def welcome(user, link)
    @user = user
    @link = link
    mail to: user.email, subject: I18n.t('caminio_welcome')
  end

end
