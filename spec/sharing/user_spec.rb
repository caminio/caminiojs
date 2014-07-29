#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-29 14:14:57
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-29 15:16:07
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

require 'spec_helper'

describe 'user' do 

  context "sharing" do 


    before(:each) do
      Caminio::ModelRegistry::init
      app = App.first
      AppModel.where( :name => "Message").first
      @unit = OrganizationalUnit.create( name: "work" )
      plan = AppPlan.create( price: 0, users_amount: 2, app: app, visible: true )
      expect( plan.errors[:app]).to eq([])
      hash = {}
      hash[app.id] = true
      @user = User.create( attributes_for(:user, organizational_units: [ @unit ] ))
      @unit.link_apps(hash)
      @user.link_app_models(hash)
      @user.save
    end

    it "must have a plan for its actions" do
      expect( User.create( attributes_for(:user, organizational_units: [ @unit ] ) ) ).to be_a( User )
      expect( User.create( attributes_for(:user, organizational_units: [ @unit ] ) ) ).to be_a( User )
    end

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
  
end