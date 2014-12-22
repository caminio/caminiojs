#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-28 15:15:01
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-29 14:58:49
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

require 'spec_helper'

describe 'organizational_unit' do

  context "attributes" do

    context "organizational_unit_name"

    context "users" do

    end


    context "app_plans" do

    end

  end

  context "private" do

    let!(:user) do
      create(:user, password: "tesT123", email: "test@test.com") 
      User.find_by( email: "test@test.com" )
    end   

    let!(:user2) do
      create(:user ) 
    end

    it "is created if no other name or unit is passed" do
      expect( OrganizationalUnit.find_by( :owner => user ).name ).to eq("private")
      other_user = User.create( attributes_for(:user, organizational_unit_name: "test" ))
      expect( OrganizationalUnit.find_by( :owner => other_user ).name ).to eq("test")      
      unit = OrganizationalUnit.create( name: "test" )
      User.create( attributes_for(:user, organizational_units: [ unit ] ))
      expect( OrganizationalUnit.find_by( name: "test" ) ).to be_a( OrganizationalUnit )
    end

    it "can only have one user" do
      private_unit = OrganizationalUnit.find_by( :owner => user )
      expect{ User.create( attributes_for(:user, organizational_units: [private_unit] )) }.to raise_error
    end

  end


end