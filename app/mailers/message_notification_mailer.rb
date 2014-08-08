class NotificationMailer < ActionMailer::Base

  include Roadie::Rails::Automatic

  def create_notification(item)

    users = get_users(item,'create')

    case item.class.name 
    when 'Message'
      create_message_notification(item)
    else  
      puts "not implemented yet"
      # TODO 
    end

    # @user = user
    # @link = link
    
    users.each do |user|
      puts user.email
      mail to: user.email
    end

  end

  def update_notification(item)

  end

  def destroy_notification(item)
    
  end

  private 

    def create_message_notification(item)
      puts item.creator.firstname
      puts item.creator.lastname

    end

    def get_users(item, type)
      model = AppModel.find_by( :name => item.class.name )
      rules = AccessRule.where( :row => item ).load
      user_list = []
      rules.each do |rule|
        user = User.find_by( :id => rule.user_id )
        role = AppModelUserRole.where( :app_model => model, :user => user ).first 
        user_list.push(user) if notify_user(user, role, model, type)
      end
      user_list
    end

    def notify_user(user, role, model, type)
      notify = user.settings['notify']
      return false unless role && notify

      if notify.is_a?(Hash)
        model = notify[model.name]
        return false unless model
        if model.is_a?(Hash)
          return false unless model[type]
        end
      end
      
      return true
        
    end

end
