# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/show' do
  let(:message) { create(:sent_message) }

  before do
    assign(:message, message)
  end

  it 'renders attributes' do
    render

    ['Content', 'Status', 'Sent At'].each { |h| expect(rendered).to include(h) }
    [message.content, message.status].each { |a| expect(rendered).to include(a) }
  end
end
