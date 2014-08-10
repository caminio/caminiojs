require 'spec_helper'

describe "message_notification_mailer"  do

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = create(:user)
    @user2 = create(:user)
    @message = Message.create_with_user(@user, { :content => 'Testcontent', :title => 'test' } )
    MessageNotificationMailer.create_notification( @user2, @message ).deliver
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it 'should send an email' do
    expect( ActionMailer::Base.deliveries.count ).to eq(1)
  end

  it 'renders the receiver email' do
    ActionMailer::Base.deliveries.first.inspect
    expect( ActionMailer::Base.deliveries.first.to.first ).to eq( @user2.email )
  end
  
  context "gets:" do

    it "user" do
      puts "TODO"
    end

    it "item"

  end

end