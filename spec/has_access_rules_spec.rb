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
    let!(:user2){ create(:user) }
    let!(:message){ create(:message, creator: user) }

    it "owner can delete" do
      expect( message.destroy ).to eq(message)
      expect( Message.find_by( id: message.id ) ).to be(nil)
     end

    it "user with rights can delete" do
      message.share(user2, {can_delete: true} )
      expect( message.with_user(user2).destroy ).to eq(message)
      expect( Message.find_by( id: message.id ) ).to eq(nil)
    end

    it "user with insufficient rights cannot delete" do
      message.share(user2)
      expect( message.with_user(user2).destroy ).to be(false)
      expect( Message.find_by( id: message.id ) ).to be_a(Message)
    end


  end

end
