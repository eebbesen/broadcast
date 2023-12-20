# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/show' do
  let(:recipient) { create(:recipient) }

  before { assign(:recipient, recipient) }

  it 'renders attributes' do
    render

    %w[Phone Status].each { |h| expect(rendered).to include(h) }
    [recipient.phone, recipient.status.capitalize].each { |h| expect(rendered).to include(h) }
  end
end
