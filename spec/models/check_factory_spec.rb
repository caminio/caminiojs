require 'spec_helper'

describe "test user" do

  before :each do
    @admin = create(:user)
    header 'Authorization', "Bearer #{@admin.aquire_api_key.token}"
    header 'organization_id', @admin.current_organization_id
  end

  describe "update" do

    describe "email" do

      before :each do
        @user = User.create( email: 'old@example.com')
        put "v1/users/#{@user.id}", { user: { email: 'new@example.com' } }
      end

      it { expect( last_response.status ).to eq(200) }
      # it { expect( json.user.email ).to eq('new@example.com') }

    end

  end

end