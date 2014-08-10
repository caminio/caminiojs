require 'spec_helper'

describe 'user_mailer' do 

  context 'reset password' do

    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @user = create(:user)
      UserMailer.reset_password( @user, 'link' ).deliver
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    it 'should send an email' do
      expect( ActionMailer::Base.deliveries.count ).to eq(1)
    end

    it 'renders the receiver email' do
      expect( ActionMailer::Base.deliveries.first.to.first ).to eq( @user2.email )
    end
  
    context "gets:" do

      it "user"

      it "link"

    end
  
  end

  context 'welcome' do

    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @user = create(:user)
      UserMailer.welcome( @user, 'link' ).deliver
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    it 'should send an email' do
      expect( ActionMailer::Base.deliveries.count ).to eq(1)
    end

    it 'renders the receiver email' do
      puts ActionMailer::Base.deliveries.first.inspect
      expect( ActionMailer::Base.deliveries.first.to.first ).to eq( @user2.email )
    end
  
    context "gets:" do

      it "user"

      it "link"

    end

  end

  
end