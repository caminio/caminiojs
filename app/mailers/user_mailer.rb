class UserMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def reset_password(user, link)
    @user = user
    @link = link
    puts "USER LANG"
    puts @user.locale
    puts "OTHER"
    puts I18n.locale
    reset = I18n.locale
    I18n.locale = @user.locale
    mail to: user.email, subject: I18n.t('caminio_password_reset')
    I18n.locale = reset
  end

  def welcome(user, link)
    @user = user
    @link = link
    reset = I18n.locale
    I18n.locale = @user.locale
    mail to: user.email, subject: I18n.t('caminio_welcome')
    I18n.locale = reset
  end

end
