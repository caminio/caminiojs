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

    let!(:user) do
      create(:user, password: "tesT123", email: "test@test.com") 
      User.find_by( email: "test@test.com" )
    end

    it("is a user") { expect(user).to be_a(User) }

    it "creates an organization_unit along with a new user" do
      expect( OrganizationalUnit.find_by( name: "private" ) ).to be_a( OrganizationalUnit )
    end

    it "adds a organizational_unit if one is passed" do
      unit = OrganizationalUnit.create( name: "test" )
      User.create( attributes_for(:user, organizational_units: [ unit ] ))
      expect( OrganizationalUnit.find_by( name: "test" ) ).to be_a( OrganizationalUnit )
    end

    it "activates messenger app to organizational_unit "

    it "assigns free plan for messenger app for organizional_unit"

  end

  context "grouping" do 

    it "can create a group"

    it "can edit a group if owner"

    it "can edit a group if got rights"

    it "can destroy a group if owner"

    it "can destroy a group if got rights"

    it "can invite other users to its group"

    it "can give other users different access levels to if owner"

  end

  context "labeling" do

    let!(:user) do
      create(:user, password: "tesT123", email: "test@test.com") 
      User.find_by( email: "test@test.com" )
    end   

    let!(:user2) do
      create(:user ) 
    end

    let!(:label) do
      create(:label, name: "a label", creator: user ) 
      Label.find_by( name: "a label" )
    end

    let!(:label2) do
      create(:label, name: "another label", creator: user2 ) 
      Label.find_by( name: "another label" )
    end

    it "can create labels" do
      expect( Label.find_by( name: "no label" ) ).to eq( nil )
      expect( Label.find_by( name: "a label" ) ).to be_a( Label )
    end

    it "gets a access_role" do
      expect( AccessRule.find_by( row_id: label.id ).user_id ).to eq( user.id )
    end

    it "can edit labels if owner" do
      expect( label.with_user(user).update( name: "new name" ) ).to eq( true )
      expect( label.with_user(user2).update( name: "other name" ) ).to eq( false )
    end

    it "can edit labels if got rights" do
      expect( label2.with_user(user).update( name: "new name" ) ).to eq( false )
      label2.with_user(user2).share(user, {can_write:true})
      expect( label2.with_user(user).update( name: "new name" ) ).to eq( true )
    end

    it "can destroy labels if owner" do 
      # expect( Label.find_by( id: label.id ) ).to eq( label ) 
      # expect( label.with_user(user2).destroy ).to eq( label )
      # puts "AFTER"
      # expect( Label.find_by( id: label.id ) ).to eq( nil ) 

      # destroyed = label.with_user(user).destroy
      # expect( destroyed ).to eq( label )
      # expect( Label.find_by( id: destroyed.id ) ).to eq( nil ) 
    end

    it "can destroy labels if got rights" do

    end

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
