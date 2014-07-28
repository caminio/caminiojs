class UserMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def reset_password(user)

    @user = user
    mail to: user.email, subject: I18n.t('caminio_password_reset')

  end

end
