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

  describe 'not signed in' do
    describe 'GET /index' do
      it 'redirects' do
        MessageRecipient.create! valid_attributes
        get message_recipients_url
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /show' do
      it 'redirects' do
        message_recipient = MessageRecipient.create! valid_attributes
        get message_recipient_url(message_recipient)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end
  end

  describe 'signed in' do
    before { sign_in(create(:user)) }

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
  end
end
