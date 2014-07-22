require 'spec_helper'

describe 'users' do

  context "attributes" do

    let(:user){ create(:user, password: "tesT123") }

    it{ expect(user).to be_a(User) }

    it{ expect( User.find_by_email(user.email).authenticate("wrong")).to eq(false) }

    it{ expect( User.find_by_email(user.email).authenticate("tesT123")).to be_a(User) }

  end

end
