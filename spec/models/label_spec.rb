#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-23 10:58:57
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-25 14:48:04
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

require 'spec_helper'

describe 'labels' do

  context "attributes" do

    let(:label){ create(:label) }

    # it{ expect(label).to be_a(Label) }

  end

  context "creation" do

    let!(:user) do
      create(:user, password: "tesT123", email: "test@test.com") 
      User.find_by( email: "test@test.com" )
    end   

    it "needs a creator" do
      expect{ create(:label) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "gets access rules for creator" do

    end

  end  

  context "usage" do

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

    it "user can create labels" do
      expect( Label.with_user(user).find_by( name: "no label" ) ).to eq( nil )
      expect( Label.with_user(user).find_by( name: "a label" ) ).to be_a( Label )
    end

    it "user gets a access_role" do
      expect( AccessRule.find_by( row_id: label.id ).user_id ).to eq( user.id )
    end

    it "user can edit labels if owner" do
      expect( Label.with_user(user).find_by(id: label.id).update( name: "new name" ) ).to eq( true )
      Label.with_user(user).find_by(id: label.id).share(user2)
      expect( Label.with_user(user2).find_by(id: label.id).update( name: "other name" ) ).to eq( false )
    end

    it "user can edit labels if got rights" do
      Label.with_user(user2).find_by(id: label2.id).share(user)
      expect( Label.with_user(user).find_by(id: label2.id).update( name: "new name" ) ).to eq( false )
      Label.with_user(user2).find_by(id: label2.id).share(user, {can_write:true})
      expect( Label.with_user(user).find_by(id: label.id).update( name: "new name" ) ).to eq( true )
    end

    it "user can destroy labels if owner" do 
      expect( Label.with_user(user).find_by(id: label.id) ).to eq(label)
      Label.with_user(user).find_by(id: label.id).share(user2)
      expect( Label.with_user(user2).find_by(id: label.id).destroy ).to be(false)
      expect( Label.with_user(user).find_by(id: label.id) ).to eq(label)
      expect( Label.with_user(user).find_by(id: label.id).destroy ).to be_a(Label)
      expect( Label.with_user(user).find_by(id: label.id) ).to eq(nil)
    end

    it "user can destroy labels if got rights" do
      Label.with_user(user).find_by(id: label.id).share(user2)
      expect( Label.with_user(user2).find_by(id: label.id).destroy ).to be(false)
      Label.with_user(user).find_by(id: label.id).share(user2,{can_delete: true})
      expect( Label.with_user(user2).find_by(id: label.id) ).to eq(label)
      expect( Label.with_user(user2).find_by(id: label.id).destroy ).to eq(label)
      expect( Label.with_user(user2).find_by(id: label.id) ).to eq(nil)
    end

  end


end