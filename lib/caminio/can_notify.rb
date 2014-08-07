module CanNotify

  extend ActiveSupport::Concern

  module ClassMethods

    def can_notify(options={})

      include InstanceMethods

      self.notify_hooks = options

    end

  end

  module InstanceMethods

    def notify_on_create
      self.class.notify_hooks[:on_create] 
    end

    def notify_on_update
      self.class.notify_hooks[:on_update] 
    end

    def notify_on_destroy
      self.class.notify_hooks[:on_destroy] 
    end

  end

    
end

ActiveRecord::Base.send :include, HasAccessRules