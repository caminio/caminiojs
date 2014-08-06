require 'spec_helper'

describe "has_translations" do

  let(:app){ create(:app) }

  it "creates fallback" do 
    before_creation = Translation.count
    app_plan = AppPlan.create( price: 0, users_amount: 2, app: app )
    expect( Translation.count ).to eq( before_creation + 1 )
    expect( app_plan.current_translation ).to be_a( Translation )
  end
  
  context "can get defaults"

  context "allows only one translation per locale and row"

end