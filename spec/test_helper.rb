# frozen_string_literal: true

require './app/helpers/recipients_helper'

TwilioSendReturn = Struct.new(:status, :sid)
TwilioStatusReturn = Struct.new(:status, :error_message)

# format Faker phone numbers at the source instead of in several tests
class Helper
  include RecipientsHelper

  class << self
    def fake_sid
      "SM#{Faker::Alphanumeric.alphanumeric(number: 32, min_alpha: 10, min_numeric: 10)}"
    end

    def fake_twilio_send(status, sid)
      TwilioSendReturn.new(status:, sid:)
    end

    def fake_twilio_status(status, error_message)
      TwilioStatusReturn.new(status:, error_message:)
    end
  end
end
