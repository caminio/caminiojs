require "spec_helper"
  
describe "user api integration" do

  # include Rack::Test::Methods

  # def app    
  #   Messages::API    
  # end

  # before(:all) do
    
  #   Caminio::ModelRegistry::init
  #   app = App.first
  #   AppPlan.create( price: 0, users_amount: 2, app: app, visible: true )

  #   User.where({}).load.delete_all
  #   @user = User.create(attributes_for(:user))
  #   @user2 = User.create( attributes_for(:user, email: "test2@example.com" ) )
  #   @message = Message.create( attributes_for(:message, creator: @user, users: [ @user2 ] ) )
  #   api_key = @user.api_keys.create
  #   api_key2 = @user2.api_keys.create
  #   @unit = @user.organizational_units.first
  #   @auth = {'HTTP_AUTHORIZATION' => "Bearer #{api_key.access_token}", 'HTTP_OU' => @unit.id }
  #   @auth2 = {'HTTP_AUTHORIZATION' => "Bearer #{api_key2.access_token}", 'HTTP_OU' => @unit.id }

  #   @hash = {}
  #   @hash[app.id] = true
  #   @user.update( organizational_units: [ @unit ] )
  #   @unit.link_apps(@hash)
  #   @user.link_app_models(@hash)
  #   @user.save


  #   @user3 = User.create( attributes_for(:user, email: "test3@example.com" ) )
  #   api_key3 = @user3.api_keys.create
  #   @auth3 = {'HTTP_AUTHORIZATION' => "Bearer #{api_key3.access_token}" }
  # end

  # context "GET /" do

end
