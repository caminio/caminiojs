#!/usr/bin/ruby
# @Author: David Reinisch
# @Date:   2014-07-31 19:10:45
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-08-01 09:35:22

require "spec_helper"
  

describe "user api integration" do

  include Rack::Test::Methods

  def app    
    Messages::API    
  end

  before(:all) do
    
    Caminio::ModelRegistry::init
    app = App.first
    AppPlan.create( price: 0, users_amount: 2, app: app, visible: true )

    User.where({}).load.delete_all
    @user = User.create(attributes_for(:user))
    api_key = @user.api_keys.create
    @unit = @user.organizational_units.first
    @auth = {'HTTP_AUTHORIZATION' => "Bearer #{api_key.access_token}", 'HTTP_OU' => @unit.id }

    @hash = {}
    @hash[app.id] = true
    @user.update( organizational_units: [ @unit ] )
    @unit.link_apps(@hash)
    @user.link_app_models(@hash)
    @user.save
  end

  context "GET /" do

    it "returns a json of all users of the current organizational unit" do
      get "/", nil, @auth
      # expect( JSON.parse( last_response.body )['users'].first['id'] ).to eq( @user.id )
    end

  end

end