# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 's3cr3T_' }

    factory :user_with_artifacts do
      messages { [association(:sent_message), association(:sent_message)] }
    end
  end
end
