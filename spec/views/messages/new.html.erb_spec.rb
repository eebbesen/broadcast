# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/new' do
  it 'renders empty form' do
    assign :message, Message.new

    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select 'textarea', ''
    end
  end
end
