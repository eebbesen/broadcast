# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MessageService' do
  let(:message_service) { MessageService.new }

  describe 'send_message' do
    it 'fails when invalid Twilio SID' do
      client = message_service
               .instance_variable_get(:@twilio_client)
               .instance_variable_get(:@client)
      orig_auth = client.instance_variable_get(:@auth)
      # ensure auth fails by setting invalid account SID

      client.instance_variable_set(:@account_sid, 'invalid')
      client.instance_variable_set(:@auth, ['invald', orig_auth[1]])
      client.instance_variable_set(:@username, 'invalid')

      message = create(:message)

      expect do
        expect do
          VCR.use_cassette('twilio_send_invalid_sid_failure_message_service') do
            message_service.send_message(message)
          end
        end.to change(Message.where(status: :failed), :count).by(1)
      end.to change(MessageRecipient.where(status: :failed), :count).by(2)
    end

    it 'fails when invalid Twilio token' do
      client = message_service
               .instance_variable_get(:@twilio_client)
               .instance_variable_get(:@client)
      orig_auth = client.instance_variable_get(:@auth)
      # ensure auth fails by setting invalid account SID
      client.instance_variable_set(:@auth_token, 'invalid')
      client.instance_variable_set(:@auth, [orig_auth[0], 'invalid'])
      client.instance_variable_set(:@password, 'invalid')

      message = create(:message)

      expect do
        expect do
          VCR.use_cassette('twilio_send_invalid_token_failure_message_service') do
            message_service.send_message(message)
          end
        end.to change(Message.where(status: :failed), :count).by(1)
      end.to change(MessageRecipient.where(status: :failed), :count).by(2)
    end

    it 'fails when no recipients' do
      message = Message.new(content: 'No recipient lists', user: create(:user), status: :unsent)

      expect(message_service.send_message(message)).not_to be_truthy
      expect(message.errors.full_messages.first).to include('No recipients associated with message')
    end

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
      end.to change(MessageRecipient.where(status: :failed), :count).by(1)
    end
  end

  describe 'update_recipient_status' do
    it 'updates status of records' do
      message_recipient = create(:queued_recipient, sid: 'SM9aa0a32fdda5e9b0007a4f6504d706d8')

      VCR.use_cassette('twilio_get_status_success') do
        message_service.update_recipient_status(message_recipient)
        message_recipient.reload
        expect(message_recipient.status).to eq(MessageRecipient.statuses[:sent])
        expect(message_recipient.last_status_check).to be_within(1.second).of(DateTime.now)
      end
    end
  end
end
