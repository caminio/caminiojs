require 'spec_helper'

describe 'user_mailer' do 

  context 'reset password' do

     before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @user = create(:user)
      @user.locale = 'de'
      @user.save
      @user2 = create(:user)
      @user2.locale = 'en'
      @user2.save
      UserMailer.reset_password( @user, 'the link' ).deliver
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    it 'should send an email' do
      expect( ActionMailer::Base.deliveries.count ).to eq(1)
    end

    it 'renders the receiver email' do
      expect( ActionMailer::Base.deliveries.first.to.first ).to eq( @user.email )
    end
  
  end

  context 'welcome' do

  

  end

  
end