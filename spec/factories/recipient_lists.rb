# frozen_string_literal: true

FactoryBot.define do
  factory :recipient_list do
    user { association(:user) }
    name { 'Park Updates' }
    recipients { create_list(:recipient, 2) }
  end
end
