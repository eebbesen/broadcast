# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/index' do
  let!(:user) { create(:user_with_artifacts) }
  let(:messages) { user.messages }

  before do
    assign(:messages, user.messages)
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
