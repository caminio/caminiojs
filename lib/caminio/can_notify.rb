# encoding: utf-8
module CanNotify

  extend ActiveSupport::Concern

  module ClassMethods

    def can_notify(options={})

      include InstanceMethods

      cattr_accessor :notification_mailer

      self.notification_mailer = options[:notification_mailer]  || NotificationMailer

    end

  end

  module InstanceMethods

    def notify_on_create
      get_users('create').each do |user|
        puts "WE GOT SOMETHING: "
        puts user.inspect
        self.notification_mailer.create_notification( user, self ).deliver
      end
    end

    def notify_on_update
      get_users('update').each do |user|
        self.notification_mailer.update_notification( user, self ).deliver
      end
    end

    def notify_on_destroy
      get_users('destroy').each do |user|
        self.notification_mailer.destroy_notification( user, self ).deliver
      end
    end

  end

  private

    # returns all users that should be notified 
    def get_users(type)
      model = AppModel.find_by( :name => self.class.name )
      rules = AccessRule.where( :row => self ).load
      user_list = []
      rules.each do |rule|
        user = User.find_by( :id => rule.user_id )
        user_list.push(user) if notify_user(user, model, type)
        if rule.is_owner && !user_list.include?(user)
          user_list.push(user) if notify_user(user, model, 'owner') 
        end
      end
      user_list
    end


    # Checks if the user wants to be notified about this action
    # Possible settings: 
    #   notify = true
    #   notify = { model_id: true }
    #   notify = { model_id: { action: true } } 
    # Action can be: 'create', 'update', 'destroy' or 'owner'
    def notify_user(user, model, type)
      notify = user.settings ? user.settings['notify'] : false

      return false unless notify

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

ActiveRecord::Base.send :include, CanNotify