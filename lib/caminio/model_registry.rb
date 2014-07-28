module Caminio

  module ModelRegistry

    def self.add( name, options={} )

      @@models ||= []
      @@models << { name: name, options: options }

    end

    def self.init
      
      @@models.each do |model|
        name = model[:options][:app_name]
        app = App.find_or_create_by( name: name )
        if model[:options].size > 0
          app_model = AppModel.find_or_create_by( name: model[:name], app_id: app.id ) 
          model[:options].delete(:app_name)
          app_model.update!( model[:options]
            .merge(hidden: !model[:options].has_key?(:icon) ) )
        end
      end
    end
      

  end

end