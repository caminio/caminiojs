require 'spec_helper'

describe Caminio::V1::ApiKeys do

  describe "/api_keys" do

    before :each do
      @user = create(:user)
      @user.organizations.create name: 'test-org'
      @api_key = create(:api_key, permanent: true, user_id: @user.id, organization_id: @user.organizations.first.id )
      @url = "v1/api_keys"
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first.id
    end

    it "returns lineup_events json" do
      get @url
      expect( last_response.status ).to be == 200
      expect( json ).to have_key(:api_keys)
    end

    describe "json return properties" do

      before :each do
        get "v1/api_keys/#{@api_key.id}"
      end

      it{ expect( json.api_key ).to have_key(:id) }
      it{ expect( json.api_key ).to have_key(:name) }
      it{ expect( json.api_key ).to have_key(:token) }

    end

  end

  describe "POST /api_keys", focus: true do

    before :each do
      @user = create(:user)
      @user.organizations.create name: 'test-org'
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
    end

    let(:url){ 'v1/api_keys' }
    let(:error_400){ 'api_key is missing' }
    let(:post_attr){ { 
      api_key: { 
        user_id: @user.id,
        name: "an api_key"
      }
    }}

    describe "requires" do

      it { post(url); expect( last_response.status ).to be == 400 }

      it { post(url); expect( json.error ).to be == error_400 }

      it { post(url, { api_key: { } } ); expect( json.error ).to be == error_400 }

    end

    describe "returns api_key" do
      
      before :each do
        post url, post_attr 
      end

      it{ expect( last_response.status ).to be == 201 }
      it{ expect( json ).to have_key :api_key }
      it{ expect( json.api_key ).to have_key(:name) }
      it{ expect( json.api_key ).to have_key(:token) }

    end

    describe "can create an permanent api_key" do

      before :each do
        @o_id = @user.organizations.first.id;
        post url, { 
          api_key: { 
            organization_id: @o_id,
            name: "permanent api_key",
            permanent: true
          }
        } 
      end

      it{ expect( last_response.status ).to be == 201 }
      it{ expect( json ).to have_key :api_key }
      it{ expect( json[:api_key].organization_id ).to match(/#{@o_id}/) }
    
    end


  end

  describe "PUT /api_keys/:id" do

    before :each do
      @user = create(:user)
      @user.organizations.create name: 'test-org'
      @api_key = create(:api_key, permanent: true, user_id: @user.id, organization_id: @user.organizations.first.id )  
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first.id
    end

    describe "update" do

      describe "name" do

        before :each do
          @new_starts = Date.new() 
          put "v1/api_keys/#{@api_key.id}", { api_key: { name: "a new name" }  }
        end

        it { expect( last_response.status ).to eq(200) }
        it { expect( json.api_key.name ).to eq( "a new name" ) }

      end

    end

  end

  describe "DELETE /api_keys/:id" do

    before :each do
      @user = create(:user)
      @user.organizations.create name: 'test-org'
      @api_key = create(:api_key, permanent: true, user_id: @user.id, organization_id: @user.organizations.first.id )      
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first.id
      delete "v1/api_keys/#{@api_key.id}"
    end

    it{ expect( last_response.status ).to be == 200 }
    it{ expect( json ).to eq({}) }

  end

end

