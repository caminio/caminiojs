require 'spec_helper'

describe 'users' do

  context "attributes" do

    let(:user){ create(:user, password: "tesT123") }

    it{ expect(user).to be_a(User) }

    it{ expect( User.find_by_email(user.email).authenticate("wrong")).to eq(false) }

    it{ expect( User.find_by_email(user.email).authenticate("tesT123")).to be_a(User) }

  end

  context "creation" do

    it "creates an organization_unit along with a new user"

    it "activates messenger app to organizational_unit "

    it "assigns free plan for messenger app for organizional_unit"

  end


end
