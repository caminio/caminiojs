#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-23 10:58:57
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-23 11:29:47
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

    it "gets access rules for all users"

  end  

  context "sharing" do

    it "can be shared with existing an existing user"

    it "can be shared with a group of existing users"

  end


end