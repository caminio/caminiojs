require 'spec_helper'

describe AppModelUserRole do

  before(:all) do
    Caminio::ModelRegistry::init
  end

  context "organizational unit plans empty" do
    let!(:ou) { create(:organizational_unit) }
    it{ expect(ou.app_plans.size).to eq(0) }
  end

  context "adds organizational unit app plan" do

    let!(:ou) { ou = create(:organizational_unit); ou.app_plans << AppPlan.first; ou }

    it{ expect( ou.app_plans.size ).to eq(1) }
    it{ expect( ou.app_plans.first.id ).to eq(AppPlan.first.id) }

  end

  context "does not add duplicate app_plans to an organizational_unit" do
    let!(:ou) { ou = create(:organizational_unit); ou.app_plans << AppPlan.first; ou }
    let!(:ou2) { ou.app_plans << AppPlan.first; ou }
    it{ expect( ou2.app_plans.size ).to eq(1) }
  end


end
