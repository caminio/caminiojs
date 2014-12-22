class Caminio::API::Users < Grape::API

  helpers Caminio::API::AuthHelper
  helpers do

    def user_params
      user_params = declared(params)[:user]
      user_params.delete(:organization_id) unless current_user.is_admin?
      user_params
    end

  end

  formatter :json, Grape::Formatter::ActiveModelSerializers

  resource :users do

    #
    # GET /
    #
    desc "lists all users"
    get do
      authenticate!
      Caminio::User.where({})
    end

    #
    # GET /current
    #
    desc "return user relation of current token"
    get '/current' do
      authenticate!
      Caminio::User.find( @token.user_id )
    end

    #
    # GET /:id
    #
    desc "returns user with :id"
    params do
      requires :id, type: Integer, desc: "the user's id"
    end
    route_param :id do
      get do
        authenticate!
        error!('InsufficientRights', 403) unless params.id == @token.user_id || @token.user.is_admin?
        Caminio::User.find_by(id: params.id)
      end
    end

    #
    # POST /
    #
    desc "create a new user within the new group"
    params do
      requires :user, type: Hash do
        requires :email
        optional :username
        optional :firstname
        optional :lastname
        optional :password
        optional :organization_id
        optional :valid_until
        optional :role, values: ['user','admin'], default: 'user'
      end
    end
    post do
      authenticate!
      Caminio::User.create( user_params )
    end

    #
    # POST /change_password
    #
    desc "changes the password for the current user"
    params do
      requires :old, desc: "the current password"
      requires :new, desc: "the new password"
    end
    post '/change_password' do
      authenticate!
      user = Caminio::User.find( @token.user_id )
      return error!("WrongPassword",403) unless user.authenticate( params.old )
      user.password = params.new
      return error("failed to save", 422) unless user.save
      Caminio::User.find( @token.user_id )
    end

    #
    # POST /signup
    #
    desc "signs up a new user account (if allowed in config)"
    params do
      requires :email, regexp: /.+@.+/
      requires :password, regexp: /(?=.*[\w0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}/
      optional :organization
      optional :username
    end
    post '/signup' do
      if Caminio::Organization.where( name: params.organization ).count > 0
        return error!('OrganizationExists',409)
      end
      if Caminio::User.where( email: params.email ).count > 0
        return error!('EmailExists',409)
      end
      user = Caminio::User.create( email: params.email, password: params.password, username: params.username )
      user.create_api_key
    end

    #
    # PUT /:id
    #
    desc "update an existing user"
    params do
      requires :user, type: Hash do
        optional :email
        optional :username
        optional :firstname
        optional :lastname
        optional :password
        optional :organization_id
        optional :role, values: ['user','admin'], default: 'user'
      end
    end
    put '/:id' do
      authenticate!
      Caminio::User.update( params.id, user_params )
      Caminio::User.find( params.id )
    end

    #
    # DELETE /:id
    #
    desc "delete an existing user"
    formatter :json, lambda{ |o,env| "{}" }
    delete '/:id' do
      authenticate!
      Caminio::User.destroy( params.id )
    end

  end

end
