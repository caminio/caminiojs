require 'spec_helper'

describe Organization do

  describe "users membership" do
  
    let!(:user){ create(:user) }

    # organizations can't be created by factory, they must be created from
    # a user object
    let!(:organization){ user.organizations.create( name: 'test-org' ) }

    it "has a member" do
      user.organizations << organization
      expect( user.organizations.size ).to be 1
    end

  end

end
