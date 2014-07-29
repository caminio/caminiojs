#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-29 14:14:57
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-29 17:46:17
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
      @hash = {}
      @hash[app.id] = true
      @user = User.create( attributes_for(:user, organizational_units: [ @unit ] ))
      @unit.link_apps(@hash)
      @user.link_app_models(@hash)
      @user.save
    end

    it "must have a plan for its actions" do
      user2 = User.create( attributes_for(:user, organizational_units: [ @unit ] ) )
      expect( user2 ).to be_a( User )
      user2.link_app_models(@hash)
      user3 = User.create( attributes_for(:user, organizational_units: [ @unit ] ) )
      expect( user3 ).to be_a( User )
      expect{ user3.link_app_models(@hash) }.to raise_error
    end

    it "can invite other users to its organizional_unit" do
      count_before = OrganizationalUnit.find_by( :name => "work").users.count
      User.create( attributes_for(:user, organizational_units: [ @unit ] ) )
      expect( OrganizationalUnit.find_by( :name => "work").users.count ).to eq( count_before + 1 )
    end

    let!(:message) do
      create(:message, title: "testmessage", creator: @user ) 
      Message.with_user(@user).find_by( title: "testmessage" )
    end

    it "can share a document with read only access" do
      user2 = User.create( attributes_for(:user) )
      message.share(user2)
      rule = AccessRule.where(:user => user2, :row_id => message.id ).first
      expect( rule ).to be_a( AccessRule )
      expect( rule.can_share ).to eq(false)
      expect( rule.can_write ).to eq(false)
      expect( rule.can_delete ).to eq(false)
      expect( rule.is_owner ).to eq(false)
    end

    it "can share a document with share access" do
      user2 = User.create( attributes_for(:user) )
      message.share(user2, { can_share: true })
      rule = AccessRule.where(:user => user2, :row_id => message.id ).first
      expect( rule ).to be_a( AccessRule )
      expect( rule.can_share ).to eq(true)
      expect( rule.can_write ).to eq(false)
      expect( rule.can_delete ).to eq(false)
      expect( rule.is_owner ).to eq(false)
    end

    it "can share a document with edit access" do
      user2 = User.create( attributes_for(:user) )
      message.share(user2, { can_write: true })
      rule = AccessRule.where(:user => user2, :row_id => message.id ).first
      expect( rule ).to be_a( AccessRule )
      expect( rule.can_share ).to eq(false)
      expect( rule.can_write ).to eq(true)
      expect( rule.can_delete ).to eq(false)
      expect( rule.is_owner ).to eq(false)
    end

    it "can share a document with full access" do
      user2 = User.create( attributes_for(:user) )
      message.share(user2, { can_delete: true })
      rule = AccessRule.where(:user => user2, :row_id => message.id ).first
      expect( rule ).to be_a( AccessRule )
      expect( rule.can_share ).to eq(false)
      expect( rule.can_write ).to eq(false)
      expect( rule.can_delete ).to eq(true)
      expect( rule.is_owner ).to eq(false)
    end

    it "can share a document with a label"

    it "can have read access to shared documents of other users"do
      user2 = User.create( attributes_for(:user) )
      user3 = User.create( attributes_for(:user) )
      message.share(user2)
      the_message = Message.with_user(user2).find_by( :id => message.id )
      expect( the_message ).to be_a( Message )
      expect( the_message.share(user3) ).to eq( false )
      expect( the_message.update( title: "new title")).to eq(false)
      expect( the_message.destroy ).to eq(false)
    end

    it "can have share access to shared documents of other users"do
      user2 = User.create( attributes_for(:user) )
      user3 = User.create( attributes_for(:user) )
      message.share(user2, { can_share: true })
      the_message = Message.with_user(user2).find_by( :id => message.id )
      expect( the_message ).to be_a( Message )
      expect( the_message.share(user3) ).to be_a( AccessRule )
      expect( the_message.update( title: "new title")).to eq(false)
      expect( the_message.destroy ).to eq(false)
    end

    it "can have write access to shared documents of other users"do
      user2 = User.create( attributes_for(:user) )
      user3 = User.create( attributes_for(:user) )
      message.share(user2, { can_write: true })
      the_message = Message.with_user(user2).find_by( :id => message.id )
      expect( the_message.share(user3) ).to eq(false)
      expect( the_message.update( title: "new title")).to eq(true)
      expect( the_message.destroy ).to eq(false)
    end

    it "can have full access to shared documents of other users" do
      user2 = User.create( attributes_for(:user) )
      user3 = User.create( attributes_for(:user) )
      message.share(user2, { can_delete: true })
      the_message = Message.with_user(user2).find_by( :id => message.id )
      expect( the_message.share(user3) ).to eq(false)
      expect( the_message.update( title: "new title")).to eq(false)
      expect( the_message.destroy ).to be_a( Message ) 
    end

  end
  
end