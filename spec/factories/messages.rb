# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    user
    content { "Upcoming construction: #{Faker::Address.street_name}" }
    status { :scheduled }
    recipient_lists { [create(:recipient_list, user:)] }

    factory :sent_message do
      content { "Parks information: #{Faker::Address.community}" }
      status { :sent }
      sent_at { DateTime.now - 3 }
      message_recipients { [association(:message_recipient)] }
    end
  end
end
