# frozen_string_literal: true

# Service to connect application to SMS sending
class MessageService
  # Fatal errors indicate auth or other account-related issue
  #  that will prevent sending to every recipient
  FATAL_ERRORS = [20003, 20404].freeze # rubocop:disable Style/NumericLiterals

  def initialize(client = TwilioClient.new)
    @twilio_client = client
  end

  def send_message(message)
    return false unless message.validate_sendable && message.valid?

    error_codes = message.list_recipients.map { |r| send_to_recipient(message, r) }

    if error_codes.intersect?(FATAL_ERRORS)
      message.status = :failed
    else
      message.status = :sent
      message.sent_at = DateTime.now
    end
    Rails.logger.info("Sent message #{message.id}")
    message.save!
  end

  def send_to_recipient(message, recipient) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    error_code = nil
    mr = MessageRecipient.new(message:, recipient:)
    begin
      result = @twilio_client.send_single(recipient.phone, message.content)
      mr.status = result.status
      mr.sid = result.sid
    rescue Twilio::REST::RestError => e
      error_code = e.code
      mr.error = e.message
      mr.status = :failed
      Rails.logger.error("Error sending message #{message.id} to #{recipient}: #{e.message}")
    ensure
      mr.save!
      Rails.logger.info("Saved message #{message.id} to #{recipient}")
      return error_code # rubocop:disable Lint/EnsureReturn
    end
  end

  # Call Twilio for recipient status per message
  # Typically this will be used to get the updated status
  #  for records with queued status
  def update_recipient_status(message_recipient)
    res = @twilio_client.get_status(message_recipient.sid)

    message_recipient.status = res.status
    message_recipient.error = res.error_message
    message_recipient.last_status_check = DateTime.now
    message_recipient.save!
  end
end
