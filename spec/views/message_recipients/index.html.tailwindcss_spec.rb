# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'message_recipients/index' do
  let(:message) { create(:sent_message) }
  let(:message_recipients) { create_list(:message_recipient, 2, message:) }

  before { assign(:message_recipients, message_recipients) }

  it 'renders a list of message_recipients' do
    render
    message_recipients.each do |mr|
      [mr.recipient.phone, mr.message.content, mr.status.capitalize]
        .each { |c| expect(rendered).to include(c) }
    end
  end
end
