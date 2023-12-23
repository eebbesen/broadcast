# frozen_string_literal: true

# interface with Twilio
class TwilioClient
  def initialize
    @client = Twilio::REST::Client
              .new(ENV.fetch('TWILIO_SID', nil), ENV.fetch('TWILIO_TOKEN', nil))
    @from = ENV.fetch('TWILIO_PHONE', nil)
  end

  # throws error with important info
  # need to catch and parse and then update message_recipient record
  # with error code and message
  def send_single(to, body)
    ret = @client.messages.create(
      from: @from,
      to: TwilioClient.format_phone(to),
      body:
    )

    Rails.logger.info("Twilio send to #{to}:\n#{ret}\nDONE")
    ret
  rescue Twilio::REST::RestError => e
    Rails.logger.error("Twilio send to #{to} failed:\n#{e}\nDONE")
    raise e
  end

  def self.format_phone(phone)
    return phone if phone.starts_with?('+1')

    "+1#{phone}"
  end
end
