#!/usr/bin/ruby
# @Author: David Reinisch
# @Date:   2014-07-29 18:29:18
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-31 18:23:15

require "spec_helper"
  

describe "user api integration" do

  include Rack::Test::Methods

  def app    
    Users::API    
  end

  before(:all) do
    
    Caminio::ModelRegistry::init
    app = App.first
    AppPlan.create( price: 0, user_quota: 2, app: app, visible: true )

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
      expect( JSON.parse( last_response.body )['users'].first['id'] ).to eq( @user.id )
    end

    it "returns an error if no valid token is passed" do
      get "/"
      expect( last_response.body ).to eq( unauthorized_error )
    end

  end

  context "GET /:id" do

    it "returns a json of the user gathered by id" do
      get "/"+@user.id.to_s, nil, @auth
      expect( JSON.parse( last_response.body )['user']['id'] ).to eq( @user.id )
    end

    it "returns an error if no valid token is passed" do
      get "/"+@user.id.to_s
      expect( last_response.body ).to eq( unauthorized_error )
    end

  end

  context "GET /:id/apps" do


    it "resturns a json of the users allowed apps in the current organizational unit" do
      get "/"+@user.id.to_s+"/apps", nil, @auth
    # expect( last_response.body ).to eq( { :ping => "pong" }.to_json )
    end

    it "returns an error if no valid token is passed"do
      get "/"+@user.id.to_s+"/apps"
      expect( last_response.body ).to eq( unauthorized_error )
    end

  end


  context "/:id/profile_picture" do

    it "returns the profile picture of the user" do

    end

    it "returns an errror if no valid token is passed"do 
      get "/"+@user.id.to_s+"/profile_picture"
      # expect( last_response.body ).to eq( unauthorized_error )
    end
  end

  def unauthorized_error
     "{\"error\":\"Unauthorized. Invalid or expired token.\"}"
  end

end
