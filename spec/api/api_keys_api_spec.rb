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

  end

  # describe "PUT /lineup_events/:id" do

  #   before :each do
  #     @user = create(:user)
  #     @lineup_entry = create(:lineup_entry)
  #     @lineup_event = @lineup_entry.events.create(starts: Date.new())      
  #     header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
  #     header 'Organization-id', @user.organizations.first
  #   end

  #   describe "update" do

  #     describe "title" do

  #       before :each do
  #         @new_starts = Date.new() 
  #         put "v1/lineup_events/#{@lineup_event.id}", { lineup_event: { starts: @new_starts }, lineup_entry_id: @lineup_entry.id  }
  #       end

  #       it { expect( last_response.status ).to eq(200) }
  #       it { expect( DateTime.parse( json.lineup_event.starts ) ).to eq( @new_starts ) }
  #       it { expect( json ).to have_key :lineup_entry }
  #       it { expect( json ).to have_key :lineup_venue }
  #       it { expect( json ).to have_key :lineup_ensembles }

  #     end

  #   end

  # end

  # describe "DELETE /lineup_events/:id" do

  #   before :each do
  #     @user = create(:user)
  #     @lineup_entry = create(:lineup_entry)
  #     @lineup_event = @lineup_entry.events.create(starts: Date.new())      
  #     header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
  #     header 'Organization-id', @user.organizations.first
  #     delete "v1/lineup_events/#{@lineup_event.id}", { lineup_entry_id: @lineup_entry.id  }
  #   end

  #   it{ expect( last_response.status ).to be == 200 }
  #   it{ expect( json ).to eq({}) }

  # end

end

