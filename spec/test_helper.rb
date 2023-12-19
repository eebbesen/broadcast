# frozen_string_literal: true

require './app/helpers/recipients_helper'

# format Faker phone numbers at the source instead of in several tests
class Helper
  include RecipientsHelper

  def fake_sid
    "MM#{Faker::Alphanumeric.alphanumeric(number: 32, min_alpha: 10, min_numeric: 10)}"
  end
end
