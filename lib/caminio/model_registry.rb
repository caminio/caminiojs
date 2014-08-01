module Caminio

  module ModelRegistry

    def self.add( name, options={} )

      @@models ||= []
      @@models << { name: name, options: options }
      Rails.logger.info "adding model #{name} to registry"

    end

    def self.init
      @@models ||= []     
      @@models.each do |model|
        app = App.find_or_create_by( name: model[:options].delete(:app_name) )
        app.update( is_public: model[:options].delete(:app_is_public) )
        if model[:options].size > 0
          app_model = AppModel.find_or_create_by( name: model[:name], app_id: app.id ) 
          app_model.update!( model[:options]
            .merge(hidden: !model[:options].has_key?(:icon) ) )
        end
      end
    end
      

  end

end
