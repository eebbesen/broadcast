# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/edit' do
  let(:recipient_list) { create(:recipient_list) }

  before do
    assign(:recipient_list, recipient_list)
  end

  it 'renders the edit recipient_list form' do
    render

    assert_select 'form[action=?][method=?]', recipient_list_path(recipient_list), 'post' do
      assert_select 'input[name=?]', 'recipient_list[name]'
    end
  end
end
