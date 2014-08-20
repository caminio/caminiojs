class UserMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def reset_password(user, link)
    @user = user
    @link = link
    puts "here #{@user.settings} #{@user.settings[:lang]} #{I18n.locale}"
    I18n.with_locale(@user.settings[:lang] || I18n.locale) do
      mail to: user.email, subject: I18n.t('caminio_password_reset')
    end
  end

  def welcome(user, link)
    @user = user
    @link = link
    I18n.with_locale(@user.settings[:lang] || I18n.locale) do
      mail to: user.email, subject: I18n.t('caminio_welcome')
    end
  end

end
