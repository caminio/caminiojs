require 'spec_helper'

describe 'translations' do

  context "attributes" do

    let(:app){ create(:app) }

    before(:each) do
      @app_plan = AppPlan.create( price: 0, users_amount: 2, app: app )
    end

    context "row_id" do

      it "is required" do
        expect( Translation.create( title: 'test' ).errors[:row] ).to include("can't be blank")
        expect( Translation.create( title: 'test', row: @app_plan ).errors[:row] ).to eq([])
      end

      it "holds the id of an object with translations" do 
        translation = Translation.create( title: 'test', row: @app_plan )
        expect( translation.row_id ).to eq( @app_plan.id )
      end

    end

    context "row_data" do

      it "is required" do
        expect( Translation.create( title: 'test' ).errors[:row] ).to include("can't be blank")
        expect( Translation.create( title: 'test', row: @app_plan ).errors[:row] ).to eq([])
      end

      it "holds the class name of an object with translations" do 
        translation = Translation.create( title: 'test', row: @app_plan )
        expect( translation.row_type ).to eq( 'AppPlan' )
      end

    end

    context "locale" do

      it "is required" do
        expect( Translation.create( title: 'test' ).errors[:locale] ).to include("can't be blank")
        expect( Translation.create( title: 'test', locale: 'en' ).errors[:locale] ).to eq([])
      end

    end

  end

  context "creation" do

    let(:app){ create(:app) }

    before(:each) do
      @app_plan = AppPlan.create( price: 0, users_amount: 2, app: app )
      @app_plan2 = AppPlan.create( price: 10, users_amount: 3, app: app )
    end

    it "each row object can only have one translation per locale" do
      expect( Translation.create( title: 'test', locale:'en', row: @app_plan ) ).to be_a( Translation )
      expect{ Translation.create( title: 'another test', locale:'en', row: @app_plan ) }.to raise_error( StandardError )
    end

  end

end