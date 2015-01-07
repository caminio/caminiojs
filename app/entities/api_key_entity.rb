module Caminio

  module API

    module Entities

      class ApiKey < Grape::Entity

        root :api_keys, :api_key

        expose :id
        expose :name
        expose :token
        expose :expires_at
        expose :permanent
        expose :user_id
        expose :organization_id
        
      end

    end

  end

end