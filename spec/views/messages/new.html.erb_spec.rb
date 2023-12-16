# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/new' do
  before do
    assign(:message, Message.new(
                       content: 'Waste collection changes for the holidays',
                       status: Message.statuses[:unsent],
                       user: nil
                     ))
  end

  it 'renders new message form' do
    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select 'input[name=?]', 'message[content]'

      assert_select 'input[name=?]', 'message[status]'

      assert_select 'input[name=?]', 'message[user_id]'
    end
  end
end
