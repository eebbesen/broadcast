# frozen_string_literal: true

FactoryBot.define do
  factory :recipient do
    status { Recipient.statuses[:verified] }
    phone { Helper.new.format(Faker::PhoneNumber.phone_number) }
  end
end
