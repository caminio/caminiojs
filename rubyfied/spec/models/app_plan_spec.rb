#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-24 16:58:50
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-28 15:27:19
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

require 'spec_helper'

describe 'app_plan' do

  context "attributes" do

    let(:app) { create(:app) }

  end

  context "creation" do

    it "must have an existing app" do 

      expect( AppPlan.create( price: 0, user_quota: 2 ).errors[:app]).to include("can't be blank")
      Caminio::ModelRegistry::init
      app = App.first
      expect( AppPlan.create( price: 0, user_quota: 2, app: app ).errors[:app]).to eq([])

    end

    it "can only be created by admin"
  
  end

  context "usage" do

    let(:user){ create(:user) }

    it "can be choosen by user" do
      Caminio::ModelRegistry::init
      app = App.first
      expect( AppPlan.create( price: 0, user_quota: 2, app: app ).errors[:app]).to eq([])

    end

    it "is bound to an organizational_unit"

    it "must be confirmed if its not a free plan"

  end

  context "visibility" do

    it "is visible if public is set"

    it "can only be changed by admin"

  end

  context "destroy" do

    it "cannot be destroyed if an organizational_unit is using this plan"

  end

end
