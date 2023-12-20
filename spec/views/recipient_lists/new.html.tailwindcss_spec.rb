# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/new' do
  let(:recipient_list) { create(:recipient_list) }

  before { assign(:recipient_list, recipient_list) }

  it 'renders new recipient_list form' do
    render

    assert_select 'input[name=?]', 'recipient_list[name]'
  end
end
