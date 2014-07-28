require 'spec_helper'

describe 'user' do

  context "attributes" do

    let(:user) do
      create(:user, password: "tesT123", email: "test@test.com") 
      User.find_by( email: "test@test.com" )
    end

    context "password" do
      
      it("is required") { expect( User.find_by_email(user.email).authenticate("tesT123")).to be_a(User)  }

      it("validation fails without") do
        expect( User.create(attributes_for(:user, password: nil) ).errors[:password]).to include("can't be blank")
      end

    end

    context "email" do
      
      it("is required") { expect(user.email).to eq("test@test.com") }

      it("validation fails without") do
        expect( User.create(attributes_for(:user, email: nil) ).errors[:email]).to include("can't be blank")
      end

    end

    it{ expect( User.find_by_email(user.email).authenticate("wrong")).to eq(false) }

  end

  context "creation" do

    it "creates an organization_unit along with a new user" do
      create(:user, password: "tesT123", email: "test@test.com") 
      expect( OrganizationalUnit.find_by( name: "private" ) ).to be_a( OrganizationalUnit )
    end

    it "adds a organizational_unit if one is passed" do
      unit = OrganizationalUnit.create( name: "test" )
      User.create( attributes_for(:user, organizational_units: [ unit ] ))
      expect( OrganizationalUnit.find_by( name: "test" ) ).to be_a( OrganizationalUnit )
    end

    it "adds the user to an organizational_unit_member for each unit" do 
      unit = OrganizationalUnit.create( name: "test" )
      cur_number = OrganizationalUnitMember.count;
      User.create( attributes_for(:user, organizational_units: [ unit ] ))
      expect( OrganizationalUnitMember.count ).to eq( cur_number + 1 )
    end

    it "gets all apps which are passed via choosen_apps" do
      Caminio::ModelRegistry::init
      app = App.first
      hash = {}
      hash[app.id] = true
      user = User.create( attributes_for(:user, choosen_apps: hash  ))
      expect( user.app_model_user_roles.count ).to eq( AppModel.count )
    end

    it "sets the access-level for the apps if passed" do


    end

    it "sets the access-level for the apps to no access by default"

    it "activates messenger app to organizational_unit "

    it "assigns free plan for messenger app for organizional_unit"

  end


  context "sharing" do

    it "must have a plan for its actions"

    it "can invite other users to its organizional_unit"

    it "can share a document with read only access"

    it "can share a document with edit access"

    it "can share a document with full access"

    it "can share a document with a group"

    it "can share a document with a label"

    it "can have read access to shared documents of other users"

    it "can have write access to shared documents of other users"

    it "can have full access to shared documents of other users"

  end

  context "destroying" do

    it "is removed from all groups"

    it "is removed from all labels"

    it "every access rule with it is destroyed"

    it "its owned organizional_unit is destroyed"

  end

end
