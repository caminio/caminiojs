#!/usr/bin/ruby
# @Author: David Reinisch
# @Date:   2014-07-29 18:29:18
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-29 18:45:52

require "spec_helper"

describe "user api integration" do

  include Rack::Test::Methods

  def app
    Users::API
  end

  before(:all) do
    # make us
    # @api_key = 
  end

  it "ping" do
    get "/", {}, {'AUTHORIZATION' => "Bearer #{api_key}"}
    expect( last_response.body ).to eq( { :ping => "pong" }.to_json )
  end

end
