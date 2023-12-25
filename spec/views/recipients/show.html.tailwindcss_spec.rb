# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/show' do
  let(:message_recipient) { create(:message_recipient) }
  let(:recipient) { message_recipient.recipient }

  before { assign(:recipient, recipient) }

  it 'renders attributes' do
    render

    ['Phone', 'Status', 'Message Count'].each { |h| expect(rendered).to include(h) }
    [recipient.phone, recipient.status.capitalize, recipient.messages.count.to_s]
      .each { |a| expect(rendered).to include(a) }
    ['Content', 'Status', 'Sent At', 'Error'].each { |h| expect(rendered).to include(h) }
    expect(recipient.messages.count).not_to be(0)
    recipient.message_recipients
             .each do |mr|
      [mr.message.content, mr.status, ui_date(mr.created_at), mr.error].compact.each do |a|
        expect(rendered).to include(a)
      end
    end
  end
end
