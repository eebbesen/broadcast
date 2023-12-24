# frozen_string_literal: true

FactoryBot.define do
  factory :message_recipient do
    message
    recipient
    status { MessageRecipient.statuses[:sent] }
    sid { Helper.fake_sid }
    last_status_check { DateTime.now - 3 }

    factory :queued_recipient do
      status { MessageRecipient.statuses[:queued] }
    end
  end
end
