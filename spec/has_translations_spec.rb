require 'spec_helper'

describe "has_translations" do

  let(:app){ create(:app) }

  it "creates fallback" do 
    app_plan = AppPlan.create( price: 0, user_quota: 2, app: app )
    expect( Translation.where( row: app_plan).count ).to eq( 1 )
    expect( app_plan.current_translation ).to be_a( Translation )
  end
  
  it "can get defaults" 

  context "allows only one translation per locale and row"

end