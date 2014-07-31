#!/usr/bin/ruby
# @Author: David Reinisch
# @Date:   2014-07-29 18:29:18
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-30 20:02:30

require "spec_helper"

describe "user api integration" do

  include Rack::Test::Methods

  def app
    Users::API
  end

  before(:all) do
    User.where({}).load.delete_all
    @user = User.create(attributes_for(:user))
    api_key = @user.api_keys.create
    @auth = {'HTTP_AUTHORIZATION' => "Bearer #{api_key.access_token}"}
  end

  it "GET /" do
    get "/", nil, @auth
    # expect( last_response.body ).to eq( { :ping => "pong" }.to_json )
  end

  context "GET /:id" do

    it "returns a json of the user gathered by id" do
      get "/"+@user.id.to_s, nil, @auth
      puts JSON.parse( last_response.body )['user']['id'].inspect
      puts @user.id
      # expect( JSON.parse( last_response.body )[:user] ).to eq( @user )
    end

    it "returns an error if no valid token is passed"

  end

  context "GET /:id/apps" do


    it "resturns a json of the users allowed apps in the current organizational unit" do
      puts "/"+@user.id.to_s+"/apps"
      get "/"+@user.id.to_s+"/apps", nil, @auth
    # expect( last_response.body ).to eq( { :ping => "pong" }.to_json )
    end

    it "returns an error if no valid token is passed"

  end

end
