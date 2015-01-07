module Caminio
  module API
    module Entities

      class Organization < Grape::Entity
        
        root :organizations, :organization

        expose :id
        expose :name
        expose :user_ids

      end

    end
  end
end
