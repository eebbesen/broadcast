# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/index' do
  let(:messages) do
    [
      create(:sent_message),
      create(:scheduled_message)
    ]
  end

  before do
    assign(:messages, messages)
  end

  it 'renders a list of messages' do
    render

    ['Content', 'Status', 'Recipients', 'Sent At']
      .each { |h| expect(rendered).to include(h) }
    messages.each do |m|
      [m.content, m.status, m.recipients.count.to_s].each { |a| expect(rendered).to include(a) }
    end
  end
end
