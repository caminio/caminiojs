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

    it{ expect(message).to be_a(Message) }

  end

  context "creation" do

    it "gets an owner"

    it "gets a followup"

    it "is attached to an access rule"

  end

  context "sharing" do

    it "can be shared with existing an existing user"

    it "can be shared with a group of existing users"

    it "can be shared with an email address"

  end

  context "access" do

  end

end