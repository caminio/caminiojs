require 'spec_helper'

describe 'has_access_rules (example: Message)' do

  context 'no has_access_rule message without a creator' do

    it{ expect{ create(:message, creator: nil) }.to raise_error ActiveRecord::RecordInvalid }

  end

  context 'rule is created along with a has_access_rule message' do

    let!(:user){ create(:user) }
    let!(:message){ create(:message, creator: user) }

    it{ expect(message).to be_a(Message) }

    it{ expect(message.access_rules.size).to eq(1) }

    it{ expect(message.access_rules.first.user_id).to eq(message.created_by) }

  end

  context 'message can be found via rules relationship' do

    let!(:user){ create(:user) }
    let!(:message){ create(:message, creator: user) }

    it{ expect(Message.with_user(user).first).to be_a(Message) }

    it{ expect(Message.with_user(user).load.size).to eq(1) }

  end

  context 'removes all rules along with message' do

    let!(:user){ create(:user) }
    let!(:message){ create(:message, creator: user) }

    it{ expect(AccessRule.count).to eq(1) }

    it "test" do
      puts message.access_rules.inspect
      test = AccessRule.find_by( row: message.id )
      # puts test.inspect
    end
    it{ Message.first.destroy; expect(AccessRule.count).to eq(0) }

  end

end
