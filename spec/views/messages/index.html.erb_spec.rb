# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/index' do
  let(:user) { create(:user) }
  let(:messages) do
    [
      create(:sent_message, user:),
      create(:scheduled_message, user:)
    ]
  end

  before do
    assign(:messages, messages)
  end

  it 'renders a list of messages' do
    render
    messages.each do |m|
      [m.content, m.status].each { |c| expect(rendered).to include(c) }
    end
  end
end
