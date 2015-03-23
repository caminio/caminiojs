require 'spec_helper'

describe Organization do

  describe "users membership" do
  
    let!(:user){ create(:user) }

    it "has a member" do
      expect( user.organizations.size ).to be 1
    end

  end

end
