require 'spec_helper'

describe AppModelUserRole do

  before(:all) do
    Caminio::ModelRegistry::init
  end

  context "user app models empty" do

    let!(:user) { create(:user) }
    it{ expect(user.app_models.size).to eq(0) }

  end

  context "adds a user model" do
    let!(:user) { u = create(:user); u.app_models << AppModel.first; u }

    it{ expect( user.app_models.size ).to eq(1) }
    it{ expect( user.app_models.first.id).to eq(AppModel.first.id) }

  end

  context "does not add duplicate entries to user model" do
    let!(:user) { u = create(:user); u.app_models << AppModel.first; u.app_models << AppModel.first; u }
    it{ expect( user.app_models.size ).to eq(1) }
  end


end
