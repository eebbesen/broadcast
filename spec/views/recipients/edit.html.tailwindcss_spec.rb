# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/edit' do
  let(:recipient) { create(:recipient) }

  before do
    assign(:recipient, recipient)
  end

  it 'renders the edit recipient form' do
    render

    assert_select 'form[action=?][method=?]', recipient_path(recipient), 'post' do
      assert_select 'input[name=?]', 'recipient[phone]'

      assert_select 'input[name=?]', 'recipient[status]'
    end
  end
end
