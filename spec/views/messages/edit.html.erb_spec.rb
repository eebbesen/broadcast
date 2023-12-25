# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/edit' do
  let!(:user) { create(:user_with_artifacts) }
  let(:message) { create(:sent_message, user:) }

  before do
    assign(:message, message)
    sign_in(user)
  end

  it 'renders the edit message form' do
    render

    assert_select 'form[action=?][method=?]', message_path(message), 'post' do
      assert_select 'textarea', message.content
      assert_select 'input[type=checkbox]'
      checkbox = assert_select("#user_recipient_list_ids_#{message.recipient_lists[0].id}")
      expect(checkbox.attribute('checked')).to be_truthy
    end
  end
end
