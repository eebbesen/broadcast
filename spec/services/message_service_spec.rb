# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MessageService' do
  let(:message_service) { MessageService.new }

  describe 'send_message' do
    it 'logs succeess when recipients are successful' do
      message = create(:message)

      expect do
        VCR.use_cassette('twilio_send_success_message_service') do
          message_service.send_message(message)
        end
      end.to change(MessageRecipient.where(status: :queued), :count).by(2)
    end

    it 'logs failures when recipients are unsuccessful' do
      invalid_recipient = create(:recipient, phone: '5005550001')
      rl = create(:recipient_list, recipients: [invalid_recipient])
      message = create(:message, recipient_lists: [rl])

      expect do
        VCR.use_cassette('twilio_send_invalid_recipient_message_service') do
          message_service.send_message(message)
        end
      end.to change(MessageRecipient.where(status: :failure), :count).by(1)
    end
  end
end
