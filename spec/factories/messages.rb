# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    user
    content { "Upcoming construction: #{Faker::Address.street_name.gsub("'", 'z')}" }
    status { :scheduled }
    recipient_lists { [create(:recipient_list, user:)] }

    factory :sent_message do
      # remove apostrophes to eliminate need for extra steps or view tests
      content { "Parks information: #{Faker::Address.community.gsub("'", 'z')}" }
      status { :sent }
      sent_at { DateTime.now - 3 }
      message_recipients { [association(:message_recipient)] }
    end

    factory :failed_message do
      status { :failed }
      after(:create) do |message, _evaluator|
        message.list_recipients
               .each do |r|
          MessageRecipient.create!(message:,
                                   recipient: r,
                                   error: 'Authentication Error',
                                   status: :failed)
        end
      end
    end
  end
end
