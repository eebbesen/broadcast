# frozen_string_literal: true

# Service to connect application to SMS sending
class MessageService
  def initialize
    @twilio_client = TwilioClient.new
  end

  def send_message(message) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    message.list_recipients.each do |r|
      mr = MessageRecipient.new(message:, recipient: r)
      begin
        res = @twilio_client.send_single(r.phone, message.content)
        mr.status = res.status
        mr.sid = res.sid
      rescue Twilio::REST::RestError => e
        mr.error = e.message
        mr.status = MessageRecipient.statuses[:failure]
        Rails.logger.error("Error sending message #{message.id} to #{r}: #{e.message}")
      ensure
        mr.save!
      end
    end
  end
end
