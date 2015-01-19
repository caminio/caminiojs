require 'spec_helper'

describe Caminio::V1::Locations do

  describe "/locations" do

    before :each do
      @user = create(:user)
      @location = create(:location)
      @url = "v1/locations"
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first
    end

    it "returns locations json" do
      get @url
      expect( last_response.status ).to be == 200
      expect( json ).to have_key(:locations)
    end

    describe "json return properties" do

      before :each do
        get "v1/locations/#{@location.id}"
      end

      it{ expect( json.location ).to have_key(:id) }
      it{ expect( json.location ).to have_key(:title) }
      it{ expect( json.location ).to have_key(:description) }

    end

  end
  describe "POST /locations", focus: true do

    before :each do
      @user = create(:user)
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
    end

    let(:url){ 'v1/locations' }
    let(:error_400){ 'location is missing, location[title] is missing' }
    let(:post_attr){ { location: { title: "a new location" } } }

    describe "requires" do

      it { post(url); expect( last_response.status ).to be == 400 }

      it { post(url); expect( json.error ).to be == error_400 }

      it { post(url, { location: { } } ); expect( json.error ).to be == error_400 }

    end

    describe "returns location" do
      
      before :each do
        post url, post_attr 
      end

      it{ expect( last_response.status ).to be == 201 }

      it{ expect( json ).to have_key :location }

    end

  end

  describe "PUT /locations/:id" do

    before :each do
      @user = create(:user)
      @location = create(:location)
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first
    end

    describe "update" do

      describe "title" do

        before :each do
          @new_title = "another location"
          put "v1/locations/#{@location.id}", { location: { title: @new_title } }
        end

        it { expect( last_response.status ).to eq(200) }
        it { expect( json.location.title ).to eq( @new_title ) }

      end

    end

  end

  describe "DELETE /locations/:id" do

    before :each do
      @user = create(:user)
      @location = create(:location)
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first
      delete "v1/locations/#{@location.id}"
    end

    it{ expect( last_response.status ).to be == 200 }
    it{ expect( json ).to eq({}) }

  end

end

