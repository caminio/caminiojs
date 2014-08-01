#
# @Author: {{author}}
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   {{create_time}}
#
# @Last Modified by:   David Reinisch
# @Last Modified time: {{last_modified_time}}
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

require 'spec_helper'

describe 'messages' do

  context "attributes" do
  
    let!(:user) { create(:user) }
    let(:message){ create(:message, creator: user )}

    it "is a message" do 
      expect(message).to be_a(Message)
    end

    context "type"

    context "row_type"

    context "row_id"

    context "important"

    context "label"

    context "content"

    context "title"

    context "children" 

    context "parent"

  end

  context "creation" do
  
    let!(:user) { create(:user) }
    let!(:user2) { create(:user, email: "test@test2.com") }
    let!(:message){ create(:message, creator: user, users: [ user2 ] )}
    let!(:message2){ create(:message, creator: user2, users: [ user ], parent: message )}

    it "can have a parent" do
      expect( message2.parent_id ).to eq(message.id)
    end

    it "can have many children" do 
      expect( message.children ).to include( message2 )
    end

    it "gets an access rule" do
      rule = AccessRule.find_by( :row_id => message.id )
      expect( rule ).to be_a( AccessRule )
    end

    it "gets an user_message for its creator" do
      expect( UserMessage.where( message: message, user: user ).first ).to be_a( UserMessage )
    end

    it "gets an user_message for each user in users" do
      expect( UserMessage.where( message: message, user: user2 ).first ).to be_a( UserMessage )
    end

    it "gets an user_message for each user in organizational_unit" do
      unit = OrganizationalUnit.create( name: "work", owner: user )
      user3 = User.create( attributes_for(:user, email: "test3@example.com", organizational_units: [ unit ] ) )
      user4 = User.create( attributes_for(:user, email: "test4@example.com", organizational_units: [ unit ] ) )
      message3 = Message.create( attributes_for(:message, creator: user, organizational_unit: unit ) )
      expect( UserMessage.where( message: message3, user: user3 ).first ).to be_a( UserMessage )
      expect( UserMessage.where( message: message3, user: user4 ).first ).to be_a( UserMessage )
    end

  end

  context "sharing" do

    it "can be shared with existing an existing user"

    it "can be shared with a group of existing users"

    it "can be shared with an email address"

  end

  context "access" do

  end

end