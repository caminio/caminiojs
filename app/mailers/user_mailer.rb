class UserMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def reset_password(user, link, host_url, logo_url)
    @user = user
    @link = link
    @host_url = host_url
    @logo_url = logo_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail to: user.email, subject: I18n.t('caminio_password_reset')
    end
  end

  def welcome(user, link, host_url, logo_url)
    @user = user
    @link = link
    @host_url = host_url
    @logo_url = logo_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail to: user.email, subject: I18n.t('caminio_welcome')
    end
  end

  def invite(user, inviter, link, host_url, logo_url)
    @user = user
    @inviter = inviter
    @host_url = host_url
    @logo_url = logo_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail to: user.email, subject: I18n.t('caminio_welcome')
    end
  end

end
