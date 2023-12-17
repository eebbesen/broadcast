# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/new' do
  let(:message) do
    Message.new(
      content: 'Waste collection changes for the holidays',
      status: Message.statuses[:unsent],
      user: nil
    )
  end

  it 'renders new message form and accepts data' do
    assign :message, message

    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select 'textarea', message.content
    end
  end

  it 'renders empty form' do
    assign :message, Message.new

    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select 'textarea', ''
    end
  end
end
