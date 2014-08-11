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
      UserMailer.reset_password( @user2, 'other link' ).deliver
      expect( ActionMailer::Base.deliveries.count ).to eq(2)
    end

    it 'renders the receiver email' do
      expect( ActionMailer::Base.deliveries.first.to.first ).to eq( @user.email )
      ActionMailer::Base.deliveries.clear
      UserMailer.reset_password( @user2, 'other link' ).deliver
      expect( ActionMailer::Base.deliveries.first.to.first ).to eq( @user2.email )
    end

    it 'renders the sender email' do
      expect( ActionMailer::Base.deliveries.first.from ).to eq( ["no-reply@camin.io"] )
    end

    it 'has the title of the message as subject' do
      reset = I18n.locale
      I18n.locale = @user.locale
      expect( ActionMailer::Base.deliveries.first.subject ).to eq( I18n.t('caminio_password_reset') )
      ActionMailer::Base.deliveries.clear
      UserMailer.reset_password( @user2, 'other link' ).deliver
      expect( ActionMailer::Base.deliveries.first.subject ).not_to eq( I18n.t('caminio_password_reset') )
      I18n.locale = reset
    end
  
  end

  context 'welcome' do

  

  end

  
end