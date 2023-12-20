# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/index' do
  let(:recipients) do
    [
      create(:recipient),
      create(:recipient, phone: '6125551111')
    ]
  end

  before { assign(:recipients, recipients) }

  it 'renders a list of recipients' do
    render
    %w[Phone Status Messages].each { |h| expect(rendered).to include(h) }
    recipients.each do |r|
      [r.phone, r.status, r.messages.count.to_s].each { |a| expect(rendered).to include(a) }
    end
  end
end
