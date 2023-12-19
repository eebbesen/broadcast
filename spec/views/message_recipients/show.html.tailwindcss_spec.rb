# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'message_recipients/show' do
  it 'renders attributes for sent message' do
    message_recipient = create(:message_recipient)
    assign :message_recipient, message_recipient

    render

    ['Status', 'Error', 'Sid', 'Content', 'Sent At', 'Phone']
      .each { |h| expect(rendered).to include(h) }
    [
      message_recipient.status.capitalize,
      message_recipient.sid,
      message_recipient.message.content,
      ui_date(message_recipient.message.sent_at),
      message_recipient.recipient.phone
    ].each do |a|
      expect(rendered).to include(a)
    end
  end

  it 'does not render error, sid, sent at for message not yet sent' do
    message = create(:scheduled_message)
    message_recipient = create(:message_recipient, message:, sid: nil)
    assign :message_recipient, message_recipient

    render

    %w[Status Content Phone]
      .each { |h| expect(rendered).to include(h) }
    [
      message_recipient.status.capitalize,
      message_recipient.message.content,
      message_recipient.recipient.phone
    ].each do |a|
      expect(rendered).to include(a)
    end
    ['Error', 'Sid', 'Sent At']
      .each { |h| expect(rendered).not_to include(h) }
  end
end
