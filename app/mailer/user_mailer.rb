class UserMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def signup(user, base_url)
    @user = user
    @base_url = base_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail(to: @user.email, subject: I18n.t('user_mailer.signup.subject', site_name: Rails.configuration.site.name))
    end
  end

  def reset_password(user, base_url)
    @user = user
    @base_url = base_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail(to: @user.email, subject: I18n.t('user_mailer.reset_pwd.subject', site_name: Rails.configuration.site.name))
    end
  end

  def invite(user, admin, base_url)
    @user = user
    @admin = admin
    @organization = admin.current_organization
    @base_url = base_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail(to: @user.email, subject: I18n.t('user_mailer.invite.subject', site_name: Rails.configuration.site.name))
    end
  end

  private
  
  def roadie_options
    super unless Rails.env.test?
  end

end
