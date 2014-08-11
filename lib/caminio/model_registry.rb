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
        if !model[:options][:app_name]
          Rails.logger.info "skipping: #{model[:name]}, caminio model registry #{model.inspect} missing key: app_name"
          next
        end
        app = App.find_or_create_by( name: model[:options].delete(:app_name) )
        app.update( hidden: !model[:options].has_key?(:icon), 
                   icon: model[:options].delete(:icon), 
                   path: model[:options].delete(:path),
                   add_js: model[:options].delete(:add_js) )
        
        app_model = AppModel.find_or_create_by( name: model[:name], app_id: app.id ) 
        app_model.update! model[:options]
        
      end
    end
      

  end

end
