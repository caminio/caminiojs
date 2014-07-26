module Caminio

  module ModelRegistry

    def self.add( name, app_id, options={} )

      @@models ||= []
      @@models << { name: name, app_id: app_id, options: options }

    end

    def self.init
      @@models.each do |model|
        if model[:options].size > 0
          app_model = AppModel.find_or_create_by( name: model[:name], app_id: model[:app_id] ) 
          app_model.update!( model[:options] )
        end
      end
    end
      

  end

end