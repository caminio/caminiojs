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

      it "fails with email address without @ (AT)" do
        expect( User.create(attributes_for(:user, email: 'bla')).errors[:email]).to include("is invalid")
      end

      it "passes with email address including @ (AT)" do
        expect( User.create(attributes_for(:user, email: 'bla@example.com')) ).to be_a(User)
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

    it "gets all apps which are passed to link_app_models" do
      Caminio::ModelRegistry::init
      app = App.first
      hash = {}
      hash[app.id] = true
      user = User.create( attributes_for(:user ))
      user.link_app_models(hash)
      user.save
      expect( user.app_model_user_roles.count ).to eq( AppModel.where(app: app).count )
    end

    it "sets the access-level for the apps if passed" do
      Caminio::ModelRegistry::init
      app = App.first
      app_model = AppModel.first
      hash = {}
      model_hash = {}
      model_hash[app_model.id] = Caminio::Access::READ
      hash[app.id] = model_hash
      user = User.create( attributes_for(:user ))
      user.link_app_models(hash)
      user.save
      expect( user.app_model_user_roles.count  ).to eq( 1 )
      expect( user.app_model_user_roles.first.access_level  ).to eq( Caminio::Access::READ.to_s )
    end


    it "assigns free plan for messenger app for organizional_unit" do 
      Caminio::ModelRegistry::init
      app = App.first
      AppModel.where( :name => "Message").first
      plan = AppPlan.create( price: 0, users_amount: 2, app: app, visible: true )
      expect( plan.errors[:app]).to eq([])
      hash = {}
      hash[app.id] = true
      user = User.create( attributes_for(:user ))
      unit = user.organizational_units.first
      unit.link_apps(hash)
      user.link_app_models(hash)
      user.save
      plan = OrganizationalUnitAppPlan.where( 
        :organizational_unit => user.organizational_units.first,
        :app_plan => plan
      ).load().first
     expect(plan).to be_a( OrganizationalUnitAppPlan )
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

    let!(:user) do
      create(:user, password: "tesT123", email: "test@test.com") 
      User.find_by( email: "test@test.com" )
    end   

    let!(:user2) do
      create(:user ) 
    end

    let!(:label) do
      create(:label, name: "a label", creator: user ) 
      Label.with_user(user).find_by( name: "a label" )
    end

    let!(:label2) do
      create(:label, name: "another label", creator: user2 ) 
      Label.with_user(user).find_by( name: "another label" )
    end 

    it "destroys its own labels if not shared" do
      before_destroy = Label.count
      user.destroy
      expect( Label.count ).to eq( before_destroy - 1 )
    end

    it "destroys its access_rules for labels" do
      Label.with_user(user).find_by(id: label.id).share(user2)
      labels_before_destroy = Label.count 
      rules_before_destroy = AccessRule.count
      user.destroy
      expect( Label.count ).to eq( labels_before_destroy )
      expect( AccessRule.count ).to eq( rules_before_destroy - 1 )
    end

    it "is removed from all labels" do 
      Label.with_user(user).find_by(id: label.id).share(user2)
      Label.with_user(user2).find_by(id: label2.id).share(user)
      rules_before_destroy = AccessRule.count
      user.destroy
      expect( label ).to be_a( Label )
      expect( label2 ).to be_a( Label )
      expect( AccessRule.count ).to eq( rules_before_destroy - 2 )
    end

    it "every access rule with it is destroyed"

    it "its owned organizional_unit is destroyed"

  end

end
