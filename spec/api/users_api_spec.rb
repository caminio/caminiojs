require 'spec_helper'

describe Caminio::V1::Users do

  describe "authentication" do

    before :each do
      @url = 'v1/users'
      @user = create(:user)
      @api_key = @user.aquire_api_key
    end

    it "requires authentication" do
      get @url
      expect(last_response).not_to be_ok
    end

    it "passes with valid api_key" do
      header 'Authorization', "Bearer #{@api_key.token}"
      header 'Organization-id', @user.organizations.create(name: 'test').id
      get @url
      expect(last_response).to be_ok
      expect(json).to have_key('users')
      expect(json.users.size).to eq(1)
    end

  end

  describe "/users/:id" do

    before :each do
      @user = create(:user)
      @user.organizations.create(name: 'test')
      @url = "v1/users/#{@user.id}"
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      header 'Organization-id', @user.organizations.first.id
    end

    it "returns a user json" do
      get @url
      expect( last_response.status ).to be == 200
      expect( json ).to have_key(:user)
    end

    describe "json return properties" do

      before :each do
        get "v1/users/#{@user.id}"
      end

      it{ expect( json.user ).to have_key(:id) }
      it{ expect( json.user ).to have_key(:username) }
      it{ expect( json.user ).to have_key(:firstname) }
      it{ expect( json.user ).to have_key(:lastname) }
      it{ expect( json.user ).to have_key(:email) }
      it{ expect( json.user ).to have_key(:admin) }
      it{ expect( json.user ).to have_key(:editor) }
      it{ expect( json.user ).not_to have_key(:password_digest) }

    end

  end

  describe "/users/current" do

    before :each do
      @user = create(:user)
      @user.organizations.create(name: 'test').id
      header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
      get 'v1/users/current'
    end

    it{ expect( json.user.id ).to be == @user.id.to_s }

  end

  describe "POST /users" do

    before :each do
      @admin = create(:user)
      @admin.organizations.create name: 'test-org'
      header 'Authorization', "Bearer #{@admin.aquire_api_key.token}"
    end

    let(:url){ 'v1/users' }
    let(:error_400){ 'user is missing, user[email] is missing' }
    let(:post_attr){ { user: { email: 'test@example.com', username: 'test' }, organization_id: @admin.current_organization_id } }

    describe "requires" do

      it { post(url); expect( last_response.status ).to be == 400 }

      it { post(url); expect( json.error ).to be == error_400 }

      it { post(url, { user: { } } ); expect( json.error ).to be == error_400 }

    end

    describe "returns user" do
      
      before :each do
        post url, post_attr 
      end

      it{ expect( last_response.status ).to be == 201 }

      it{ expect( json ).to have_key :user }

    end

    describe "private organization" do

      before :each do 
        post url, post_attr
      end

      it{ expect( json.user.organization_ids.size ).to be == 1 }

    end

  end

  describe "PUT /:id" do

    before :each do
      @admin = create(:user)
      @admin.organizations.create name: 'test-org'
      header 'Authorization', "Bearer #{@admin.aquire_api_key.token}"
      header 'organization_id', @admin.current_organization_id
    end

    describe "update" do

      describe "email" do

        before :each do
          @user = create(:user, email: 'old@example.com')
          put "v1/users/#{@user.id}", { user: { email: 'new@example.com' } }
        end

        it { expect( last_response.status ).to eq(200) }
        it { expect( json.user.email ).to eq('new@example.com') }

      end

    end

  end

  describe "DELETE /:id" do

    before :each do
      @admin = create(:user)
      @admin.organizations.create name: 'test-org'
      header 'Authorization', "Bearer #{@admin.aquire_api_key.token}"
      header 'organization_id', @admin.current_organization_id
      @user = create(:user, email: 'deleteme@example.com')
      delete "v1/users/#{@user.id}"
    end

    it{ expect( last_response.status ).to be == 200 }
    it{ expect( json ).to eq({}) }

  end

  describe "POST /change_password" do

    describe "pass" do

      before :each do
        @user = create(:user, username: 'test', password: 'test-old')
        @user.organizations.create(name: 'test').id
        header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
        post "v1/users/change_password", old: 'test-old', new: 'test-new'
      end

      it { expect(last_response.status).to be == 201 }

      describe "can log in with new password" do

        before :each do
          post "v1/auth", login: 'test', password: 'test-new'
        end

        it { expect(last_response.status).to be == 201 }
        it { expect(json).to have_key(:api_key) }
        it { expect(json.api_key).to have_key(:token) }

      end

      describe "can't log in with old password" do

        before :each do
          post "v1/auth", login: 'test', password: 'test-old'
        end

        it { expect(last_response.status).to be == 401 }
        it { expect(json).not_to have_key(:api_key) }
        it { expect(json).to have_key(:error) }
        it { expect(json.error).to eq("InvalidCredentials") }

      end
    end

    describe "fails" do

      before :each do
        @user = create(:user, username: 'test', password: 'test-old')
        header 'Authorization', "Bearer #{@user.aquire_api_key.token}"
        post "v1/users/change_password", old: 'test-invalid', new: 'test-new'
      end

      it { expect(last_response.status).to be == 403 }

      it { expect(json).to have_key(:error) }
      it { expect(json.error).to eq("WrongPassword") }

    end

  end

  describe :signup do

    before :each do
      @email_addr = 'test@example.com'
      @deliveries_count = ActionMailer::Base.deliveries.count
      post "v1/users/signup", email: @email_addr, password: 'Test1234'
    end

    describe "sends an email" do

      let(:email){ ActionMailer::Base.deliveries.last }
      let(:user){ User.last }

      it "queued" do
        expect(ActionMailer::Base.deliveries.count).to eq( @deliveries_count+1)
      end

      it "subject matches string" do
        expect( email.subject ).to eq "Your account on caminiotest"
      end

      it "recipients size == 1" do
        expect( email.to.size ).to eq 1
      end

      it "matches recipients email address" do
        expect( email.to.first ).to eq @email_addr
      end

      it "includes code in body" do
        expect( email.body.to_s ).to match(/#{user.confirmation_code}/)
      end

    end

    it { expect(last_response.status).to be == 201 }

    it { expect(json).to have_key(:confirmation_key) }

    it { expect(json).to have_key(:id) }

    it { expect(User.first.confirmation_key).to be == json['confirmation_key'] }

    it { expect(User.first.id.to_s).to be == json['id'] }

    it { expect(User.first.confirmed?).to be false }

  end

  describe :confirm do

    before :each do
      @user = create(:user)
      @user.organizations.create name: 'test-org'
      post "v1/users/#{@user.id}/confirm", confirmation_key: @user.confirmation_key, confirmation_code: @user.confirmation_code
    end

    it { expect(last_response.status).to be == 200 }

    it { expect(json).to have_key(:api_key) }

    it { expect(User.first.confirmed?).to be true }

  end

end
