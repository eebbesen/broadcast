# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    user

    factory :sent_message do
      content { 'Parks information' }
      status { 'SENT' }
      sent_at { DateTime.now - 3 }
    end

    factory :scheduled_message do
      content { 'Upcoming construction' }
      status { 'SCHEDULED' }
    end
  end
end
