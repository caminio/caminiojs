require 'spec_helper'

describe Caminio::V1::Mediafiles do

  describe "POST /mediafiles" do

    before :each do
      @user = create(:user)
      @user.organizations.create name: "testorg"
      @url = "v1/mediafiles"
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first.id
    end

    it "returns mediafiles json" do
      path = Rails.root + '../../spec/support/images/test.jpg'
      post @url, { file: Rack::Test::UploadedFile.new(path, "image/jpeg"), parent_id: @user.id, parent_type: "User" }
      puts json.inspect
      expect( last_response.status ).to be == 201
      expect( json ).to have_key(:mediafile)
    end
  end

end

