# frozen_string_literal: true

require './app/helpers/recipients_helper'

# format Faker phone numbers at the source instead of in several tests
class Helper
  include RecipientsHelper
end

FactoryBot.define do
  factory :recipient do
    status { Recipient.statuses[:verified] }
    phone { Helper.new.format(Faker::PhoneNumber.phone_number) }
  end
end
