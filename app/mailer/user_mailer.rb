class UserMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def signup(user, code)
    @user = user
    @code = code
    I18n.with_locale(@user.locale || I18n.locale) do
      mail to: @user.email, subject: I18n.t('user_mailer.signup.welcome')
    end
  end

end
