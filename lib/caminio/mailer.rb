require 'action_mailer'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address   => "smtp.gmail.com",
   :port      => 587,
   :domain    => "domain.com.ar",
   :authentication => :plain,
   :user_name      => "test@domain.com.ar",
   :password       => "passw0rd",
   :enable_starttls_auto => true
  }
ActionMailer::Base.view_paths= File.dirname(__FILE__)

class Mailer < ActionMailer::Base

  def daily_email
    @var = "var"

    mail(   :to      => "myemail@gmail.com",
            :from    => "test@domain.com.ar",
            :subject => "testing mail") do |format|
                format.text
                format.html
    end
  end
end

email = Mailer.daily_email
puts email
email.deliver