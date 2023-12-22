# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/show' do
  let(:message) { create(:sent_message) }

  before do
    assign(:message, message)
  end

  it 'renders attributes' do
    render

    ['Content', 'Status', 'Sent At', 'Recipient Lists', 'Recipients']
      .each { |h| expect(rendered).to include(h) }
    [
      message.content,
      message.status.capitalize,
      ui_date(message.sent_at),
      message.message_recipients.count.to_s
    ].each { |a| expect(rendered).to include(a) }
    %w[Phone Status Error].each { |h| expect(rendered).to include(h) }
    message.message_recipients.each do |mr|
      [mr.recipient.phone, mr.status].each { |a| expect(rendered).to include(a) }
    end
  end
end
