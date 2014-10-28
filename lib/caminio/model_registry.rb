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
        app_model = AppModel.find_or_create_by( name: model[:name], app_id: app.id ){ |app_model| app_model.hidden = model[:hidden] }
        app_model.update! model[:options] if model[:options].size > 0
        
      end
    end
      

  end

end
