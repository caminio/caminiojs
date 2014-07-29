require 'spec_helper'

describe 'free plan' do

  context "share the message application with another email address" do

    before(:all) do
      Caminio::ModelRegistry::init
      app = App.first
      AppModel.where( :name => "Message").first
      @unit = OrganizationalUnit.create( name: "work" )
      plan = AppPlan.create( price: 0, users_amount: 2, app: app, visible: true )
      expect( plan.errors[:app]).to eq([])
      @hash = {}
      @hash[app.id] = true
      @user = User.create( attributes_for(:user, organizational_units: [ @unit ] ))
      @unit.link_apps(@hash)
      @user.link_app_models(@hash)
      @user.save
    end

    it "verifies if plan users_amount has enough users left" do 
      user2 = User.create( attributes_for(:user, organizational_units: [ @unit ] ) )
      expect( user2 ).to be_a( User )
      user2.link_app_models(@hash)
      user3 = User.create( attributes_for(:user, organizational_units: [ @unit ] ) )
      expect( user3 ).to be_a( User )
      expect{ user3.link_app_models(@hash) }.to raise_error
    end

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
