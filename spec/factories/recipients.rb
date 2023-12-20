# frozen_string_literal: true

FactoryBot.define do
  factory :recipient do
    status { Recipient.statuses[:verified] }
    phone { Faker::Number.number(digits: 10) }
  end
end
