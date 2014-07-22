require 'spec_helper'

describe 'users' do

  context "attributes" do

    let(:user){ build(:user) }

    it{ expect(build(:user)).to be_a(User) }

  end

end
