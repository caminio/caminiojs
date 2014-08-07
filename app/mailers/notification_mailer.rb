class NotificationMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def on_create(item)

    @users =[]
    puts item.row_type
    case item.row_type 
    when 'Message'
      puts "Its a message"
    else  
      puts "Its another thing"
    end

    # TODO
    # @user = user
    # @link = link
    
    @users.each do |user|
      mail to: user.email, subject: I18n.t(@subject||'Something was created')
    end

  end

  def welcome(user, link)
    # TODO
    # @user = user
    # @link = link
    # mail to: user.email, subject: I18n.t('caminio_welcome')
  end

  private 

end
