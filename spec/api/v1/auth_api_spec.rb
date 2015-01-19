require 'spec_helper'

describe V1::AuthApi do

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
      user = create :user
      post 'v1/auth', login: user.username, password: user.password
    end

    it{ puts json.inspect; expect( json ).to have_key('api_key') }
    it{ expect( json['api_key'] ).to have_key('token') }
    it{ expect( json['api_key'] ).to have_key('expires_at') }
    it{ expect( json['api_key'] ).to have_key('user_id') }

    describe "token length" do
  
      it{ expect( json['api_key']['token'].size ).to eq(32) }

    end

    describe "user" do
      it { expect( json['api_key']['user_id'] ).to eq(user.id)  }
    end

    describe "expiration date" do
      it{ expect( Time.parse(json['api_key']['expires_at']) ).to be >= (7*60+59).minutes.from_now }
      it{ expect( Time.parse(json['api_key']['expires_at']) ).to be <= (8*60+1).minutes.from_now }

    end

  end

end