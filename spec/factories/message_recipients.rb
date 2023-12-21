# frozen_string_literal: true

FactoryBot.define do
  factory :message_recipient do
    message
    recipient
    status { MessageRecipient.statuses[:success] }
    sid { Helper.new.fake_sid }
  end
end
