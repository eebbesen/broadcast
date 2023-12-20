# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/show' do
  let(:recipient_list) { create(:recipient_list) }

  before { assign(:recipient_list, recipient_list) }

  it 'renders attributes' do
    render
    expect(rendered).to include('Name')
    expect(rendered).to include(recipient_list.name)
  end
end
