# frozen_string_literal: true

FactoryBot.define do
  factory :recipient do
    phone { '6515551212' }
    status { Recipient.statuses[:verified] }
  end
end
