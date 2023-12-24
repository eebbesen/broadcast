# frozen_string_literal: true

# Service to connect application to SMS sending
class MessageService
  def initialize(client = TwilioClient.new)
    @twilio_client = client
  end

  def send_message(message)
    message.list_recipients.each { |r| send_to_recipient(message, r) }
    message.status = Message.statuses[:sent]
    message.sent_at = DateTime.now
    message.save!
  end

  def send_to_recipient(message, recipient) # rubocop:disable Metrics/MethodLength
    mr = MessageRecipient.new(message:, recipient:)
    begin
      result = @twilio_client.send_single(recipient.phone, message.content)
      mr.status = result.status
      mr.sid = result.sid
    rescue Twilio::REST::RestError => e
      mr.error = e.message
      mr.status = MessageRecipient.statuses[:failed]
      Rails.logger.error("Error sending message #{message.id} to #{recipient}: #{e.message}")
    ensure
      mr.save!
    end
  end

  def update_recipient_status(message_recipient)
    res = @twilio_client.get_status(message_recipient.sid)

    message_recipient.status = res.status
    message_recipient.error = res.error_message
    message_recipient.last_status_check = DateTime.now
    message_recipient.save!
  end
end
