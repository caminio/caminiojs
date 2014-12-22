class UserMailer < ActionMailer::Base

  def signup
    mail(   :to      => "myemail@gmail.com",
            :from    => "test@domain.com.ar",
            :subject => "testing mail") do |format|
                format.text
                format.html
    end
  end
end