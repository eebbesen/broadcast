# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/edit' do
  let(:message) do
    create(:sent_message)
  end

  before do
    assign(:message, message)
  end

  it 'renders the edit message form' do
    render

    assert_select 'form[action=?][method=?]', message_path(message), 'post' do
      assert_select 'input[name=?]', 'message[content]'

      assert_select 'input[name=?]', 'message[status]'

      assert_select 'input[name=?]', 'message[user_id]'
    end
  end
end
