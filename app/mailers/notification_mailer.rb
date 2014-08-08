class NotificationMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def create_notification(item)

    @users =[]
    case item.class.name 
    when 'Message'
      puts "Its a message"
    else  
      puts "Its another thing"
      # TODO
    end

    # @user = user
    # @link = link
    
    @users.each do |user|
      mail to: user.email, subject: I18n.t(@subject||'Something was created')
    end

  end

  def get_users(item)
    rules = AccessRule.find_by( :row => item )
    rules.each do |rule|


    end
  end

  def update_notification(item)

  end

  def destroy_notification(item)
    
  end

  private 

end
