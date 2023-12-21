# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/index' do
  let(:recipients) do
    create(:sent_message).recipients
  end

  before { assign(:recipients, recipients) }

  it 'renders a list of recipients' do
    render
    %w[Phone Status Messages].each { |h| expect(rendered).to include(h) }
    recipients.each do |r|
      expect(r.messages.count).not_to be(0)
      [r.phone, r.status, r.messages.count.to_s].each { |a| expect(rendered).to include(a) }
    end
  end
end
