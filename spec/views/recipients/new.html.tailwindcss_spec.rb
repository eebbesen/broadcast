# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/new' do
  before { assign(:recipient, Recipient.new) }

  it 'renders new recipient form' do
    render

    assert_select 'form[action=?][method=?]', recipients_path, 'post' do
      assert_select 'input', ''
    end
  end
end
