# frozen_string_literal: true

FactoryBot.define do
  factory :message_recipient do
    message { association(:sent_message) }
    recipient
    status { MessageRecipient.statuses[:success] }
    sid { "MM#{Faker::Alphanumeric.alphanumeric(number: 32, min_alpha: 10, min_numeric: 10)}" }
  end
end
