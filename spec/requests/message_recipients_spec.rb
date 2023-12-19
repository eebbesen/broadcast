# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/message_recipients' do
  # This should return the minimal set of attributes required to create a valid
  # MessageRecipient. As you add validations to MessageRecipient, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { message: create(:sent_message), recipient: create(:recipient), status: MessageRecipient.statuses[:pending] }
  end

  let(:invalid_attributes) do
    { mesage: create(:sent_message), recipient: create(:recipient) }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      MessageRecipient.create! valid_attributes
      get message_recipients_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      message_recipient = MessageRecipient.create! valid_attributes
      get message_recipient_url(message_recipient)
      expect(response).to be_successful
    end
  end

  # no view for this, just API since we don't want humans editing
  describe 'GET /edit' do
    it 'renders a successful response' do
      message_recipient = MessageRecipient.create! valid_attributes
      get edit_message_recipient_url(message_recipient), as: :json
      expect(response).to be_successful
    end
  end
end
