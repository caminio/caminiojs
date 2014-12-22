require 'spec_helper'

describe "message_notification_mailer"  do

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = create(:user)
    @user.locale = 'de'
    @user.save
    @user2 = create(:user)
    @user2.locale = 'de'
    @user2.save
    @message = Message.create_with_user(@user, { :content => 'Testcontent', :title => 'test', :users => [@user2] } )
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

  it 'renders the sender email' do
    expect( ActionMailer::Base.deliveries.first.from ).to eq( ["no-reply@camin.io"] )
  end

  it 'has the title of the message as subject' do
    expect( ActionMailer::Base.deliveries.first.subject ).to eq( @message.title )
  end
  

end