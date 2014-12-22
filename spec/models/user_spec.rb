require 'spec_helper'

describe Caminio::User do

  describe "create" do
  
    let!(:user){ create(:user) }

    it { expect(user).to be_a(Caminio::User) }
    it { expect(user.username).to eq('johndoe') }
    it { expect(Caminio::User.where( username: 'johndoe' ).first ).not_to be(nil) }
    it { expect(Caminio::User.where( username: 'johndoe' ).first ).to be_a(Caminio::User) }

  end

  describe "update" do

    let!(:user) do
      user = create(:user, username: 'test-update')
      user.update( username: 'test2' )
      user
    end

    it { expect(Caminio::User.find_by( username: 'test2' )).not_to be(nil) }
    it { expect(Caminio::User.find_by( username: 'test-update' )).to be(nil) }

  end

  describe "delete" do

    let!(:user) do
      user = create(:user, username: 'test-delete')
      user.destroy
    end

    it { expect(Caminio::User.find_by( username: 'test-delete')).to be(nil) }

  end

  describe "api_key" do

    let!(:user){ create(:user) }

    describe "creates a new access token" do
      
      let!(:api_key){ user.aquire_api_key }

      it { expect( api_key ).to be_a(Caminio::ApiKey) }

      it { expect( api_key.token.size ).to eq(32) }

      it { expect( api_key.expires_at ).to be >= (8*60-1).minutes.from_now }

      it { expect( api_key.expires_at ).to be <= (8*60+1).minutes.from_now }

      describe "invalidates old api_key if new is aquired" do

        it "only finds one valid token" do
          new_token = user.aquire_api_key
          expect( new_token.id ).not_to eq( api_key.id )
          expect( Caminio::ApiKey.find_by( id: api_key.id ) ).to be(nil)
        end

      end

    end


  end

  describe "roles" do

    let!(:user){ create(:user) }

    describe "defaults to user" do
    
      it{ expect( user.role ).to eq('user') }

    end

    describe "is_admin?" do

      let!(:admin){ create(:user, role: 'admin') }

      it{ expect( user.is_admin? ).to be false }

      it{ expect( admin.is_admin? ).to be true }

    end

  end

  describe "locale" do

    let!(:user){ create(:user) }
    it{ expect( user.locale ).to eq I18n.default_locale.to_s }

  end

end
