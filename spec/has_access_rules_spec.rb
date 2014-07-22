require 'spec_helper'

describe 'has_access_rules (example: Message)' do

  context 'creation' do

    let(:message){ create(:message) }

    it{ expect(message).to be_a(Message) }

    it{ expect(message.access_rules.size).to eq(1) }


  end

end
