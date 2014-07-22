require 'spec_helper'

describe 'free plan' do

  context "share a message with another email address" do

    it "verifies if plan users_amount has enough users left"

    it "creates a new user and attaches it to creator's organizational_unit"

    it "sets invited user to uncomfirmed status"

  end

  context "exceed amount of allowed users to share a message" do

    it "fails to invite user that exceeds allowed amount"

  end

end

describe 'paid plan' do

  context "change plan from free to paid" do
 
    it "existing free plan's id is swapped with paid plan's id"

    it "max users amount increased to paid plans' max users amount"


  end

  context "invite one more user" do

    it "succeeds in verifying plan has enough users left"

    it "creates a new user and attaches it to creator's organizational_unit"

  end

end
