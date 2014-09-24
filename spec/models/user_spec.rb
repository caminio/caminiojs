require 'spec_helper'

describe 'user' do

  context "attributes" do

    let(:user) do
      User.where(:email.ne => '').each(&:destroy)
      create(:user, password: "tesT123", email: "test@example.com") 
    end

    context "name" do

      it "returns firstname + lastname if both are set" do
        expect( user.name ).to eq( user.firstname  + ' ' + user.lastname )
      end 

      it "returns lastname if no firstname is set" do
        user[:firstname] = nil
        expect( user.name ).to eq( user.lastname )
      end

      it "returns email if no lastname is set" do
        user[:lastname] = nil
        expect( user.name ).to eq( user.email )
      end

    end

    context "password" do
      
      it("is required") { expect( User.find_by(email: user.email).authenticate("tesT123")).to be_a(User)  }

      it("validation fails without") do
        expect( User.create(attributes_for(:user, password: nil) ).errors[:password]).to include("can't be blank")
      end

    end

    context "email" do
      
      it("is required") { expect(user.email).to eq("test@example.com") }

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

    context "locale" do

      it "is required" do
          expect( User.create(attributes_for(:user, locale: 'de')).locale ).to eq('de')
      end

      it "is set do the I18n locale by default" do
        expect( user.locale ).to eq( I18n.locale.to_s )
      end

    end

    context "organizational_units" do

      it "always got a private unit" do
        expect( user.organizational_units.first.name ).to eq("private")
      end

    end

    it{ expect( User.find_by(email: user.email).authenticate("wrong")).to eq(false) }

  end

  context "creation" do

    let(:user) do
      User.where(:email.ne => '').each(&:destroy)
      create(:user, password: "tesT123", email: "test@example.com") 
    end

    let(:app) do
      App.where({}).each(&:destroy)
      create(:app)
    end

    let(:app_plan) do
      AppPlan.where({}).each(&:destroy)
      app.app_plans.create( price: 0, user_quota: 2, hidden: false )
    end

    let(:organizational_unit) do
      user.organizational_units.first
    end

    it "adds a organizational_unit if one is passed" do
      unit = OrganizationalUnit.create( name: "test" )
      User.create( attributes_for(:user, organizational_units: [ unit ] ))
      expect( OrganizationalUnit.find_by( name: "test" ) ).to be_a( OrganizationalUnit )
    end

    it "adds the user to an organizational_unit_member for each unit" do 
      unit = OrganizationalUnit.create( name: "test" )
      cur_number = unit.users.count
      user = create(:user)
      user.organizational_units << unit
      user.save
      expect( unit.reload.users.count ).to eq( cur_number + 1 )
    end

    it "links apps to organizational unit" do
      expect( organizational_unit.app_plans.count ).to eq( 0 )
      organizational_unit.app_plans << app_plan
      expect( organizational_unit.app_plans.count ).to eq( 1 )
    end

    it "sets the access-level for the apps if passed" do
      organizational_unit.app_plans << app_plan
      organizational_unit.save
      expect( organizational_unit.access_for_user(user).can_write ).to eq( true )
    end

  end

end
