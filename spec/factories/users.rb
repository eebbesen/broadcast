# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@com.com' }
    password { 's3cr3T_' }
  end
end
