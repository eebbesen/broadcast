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
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Phone'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Status'.to_s), count: 2
  end
end
