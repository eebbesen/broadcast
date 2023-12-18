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
    recipients.each do |r|
      [r.phone, r.status].each { |c| expect(rendered).to include(c) }
    end
  end
end
