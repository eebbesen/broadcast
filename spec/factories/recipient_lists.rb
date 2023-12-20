# frozen_string_literal: true

FactoryBot.define do
  factory :recipient_list do
    user
    name { 'Park Updates' }
  end
end
