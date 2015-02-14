require 'spec_helper'

describe Caminio::V1::Auth do

  let(:user){ create(:user) }

  it "@username and @password" do
    post 'v1/auth', login: user.username, password: user.password
    expect( last_response.status ).to be == 201
    expect( last_response.content_type ).to eq('application/json')
  end

  it "@email and @password" do
    post 'v1/auth', login: user.email, password: user.password
    expect( last_response.status ).to be == 201
  end

  it "fails with @password+1 char" do
    post 'v1/auth', login: user.email, password: "#{user.password}x"
    expect( last_response.status ).to be == 401
    expect( last_response.content_type ).to eq('application/json')
    expect( json ).to have_key('error')
  end

  it "fails with wrong login" do
    post 'v1/auth', login: 'invalid', password: user.password
    expect( last_response.status ).to be == 401
  end

  it "fails with wrong password" do
    post 'v1/auth', login: user.username, password: 'invalid'
    expect( last_response.status ).to be == 401
  end

  it "fails with wrong login and password" do
    post 'v1/auth', login: 'invalid', password: 'invalid'
    expect( last_response.status ).to be == 401
  end

  describe "returns an access token" do

    before :all do
      @user = create :user
      post 'v1/auth', login: @user.username, password: @user.password
    end

    it{ expect( json ).to have_key('api_key') }
    it{ expect( json['api_key'] ).to have_key('token') }
    it{ expect( json['api_key'] ).to have_key('expires_at') }
    it{ expect( json['api_key'] ).to have_key('user_id') }

    describe "token length" do
  
      it{ expect( json['api_key']['token'].size ).to eq(32) }

    end

    describe "user" do
      it { expect( json['api_key']['user_id'] ).to eq(@user.id.to_s)  }
    end

    describe "expiration date" do
      it{ expect( Time.parse(json['api_key']['expires_at']) ).to be >= (7*60+59).minutes.from_now }
      it{ expect( Time.parse(json['api_key']['expires_at']) ).to be <= (8*60+1).minutes.from_now }
    end

  end

  describe "/auth/test_public_key" do

    before :each do
      @user = create(:user)
      @user.organizations.create name: 'test-org'
      @api_key = create(:api_key, permanent: true, organization_id: @user.organizations.first.id )
      @url = "v1/auth/test_public_key"
      header 'Authorization', "Bearer #{@api_key.token}"
    end

    it "tests a pulic key" do
      post @url
      expect( last_response.status ).to be == 201
    end

    it "returns the api_key: true" do
      post @url
      expect( json ).to have_key('api_key')
      expect( json[:api_key].id ).to eq (@api_key.id.to_s)
    end

    # it "sets the current_api_key in store" do 
    #   post @url
    #   expect( RequestStore.store['current_api_key_id'] ).to eq( @api_key.id )
    # end 

  end

  describe "/auth/request_token" do

    before :each do
      @user = create(:user)
      @user.organizations.create name: 'test-org'
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first.id
    end

    it "returns lineup_events json" do
      @request_tokens_size =  @user.api_keys.first.request_tokens.size
      expect( @request_tokens_size ).to be == 0
      get "v1/auth/request_token"
      expect( last_response.status ).to be == 200
      expect( json ).to have_key(:request_token)
      expect( json[:request_token] ).to have_key(:token)
      expect( @user.api_keys.first.request_tokens.size ).to be == @request_tokens_size + 1
    end

    it "removes old tokens" do      
      @user.api_keys.first.request_tokens.create
      old_token = @user.api_keys.first.request_tokens.first
      old_token.expires_at = ( Date.today - 1 ).to_datetime
      old_token.save
      @request_tokens_size =  @user.api_keys.first.request_tokens.size
      get "v1/auth/request_token"
      expect( @user.api_keys.first.request_tokens.size ).to be == @request_tokens_size
    end

  end

end
