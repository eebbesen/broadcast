# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

require './spec/test_helper'
require 'factory_bot_rails'
include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
unless %w[test development].include?(Rails.env)
  throw Exception.new('seeds have sensitive data, do not run in production')
end
ActiveRecord::Base.transaction do
  # create a user in the console
  User.create!(email: 'you@you.you', password: 'retek01!')

  # recipients
  3.times do
    Recipient.create!(phone: Faker::Number.number(digits: 10), status: :verified)
  end
  2.times do
    Recipient.create!(phone: Faker::Number.number(digits: 10), status: :unverified)
  end

  # recipient lists
  rl1 = RecipientList.create(name: 'Park Programs', user: User.first)
  rl1.recipients << Recipient.limit(2)

  rl2 = RecipientList.create(name: 'Yard Waste', user: User.first)
  rl2.recipients << Recipient.limit(3)

  # messages
  m1 = Message.create!(content: 'Thank you for subscribing to park information messages',
                       user: User.first, status: :sent,
                       sent_at: (DateTime.now - 4))
  m2 = Message.create!(content: 'Holiday garbage collection date changes',
                       user: User.first, status: :unsent)

  Recipient.where(status: :verified).find_each do |r|
    MessageRecipient.create!(message: m1, recipient: r,
                             sid: Helper.fake_sid, status: :queued)
  end
  MessageRecipient.create!(message: m1, recipient: create(:recipient),
                           sid: Helper.fake_sid, status: :failed,
                           error: 'Not a mobile number')
  MessageRecipient.create!(message: m2, recipient: create(:recipient),
                           sid: Helper.fake_sid, status: :pending)

  m1.recipient_lists << rl1
  m2.recipient_lists << rl2
end

# rubocop:enable Metrics/BlockLength
