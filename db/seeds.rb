# frozen_string_literal: true

require './app/helpers/recipients_helper'
require 'factory_bot_rails'
include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage

# Data helper
class Helper
  include RecipientsHelper

  def fake_sid
    "MM#{Faker::Alphanumeric.alphanumeric(number: 32, min_alpha: 10, min_numeric: 10)}"
  end
end
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# create a user in the console
# User.create!(email: 'you@you.you', password: 'S3kr!t_')

User.create!(email: 'you@you.you', password: 'retek01!')

Message.create!(content: 'Thank you for subscribing to park information messages',
                user: User.first, status: Message.statuses[:sent],
                sent_at: (DateTime.now - 4))
Message.create!(content: 'Holiday garbage collection date changes',
                user: User.first, status: Message.statuses[:unsent])

3.times do
  Recipient.create!(phone: Helper.new.format(Faker::PhoneNumber.phone_number),
                    status: Recipient.statuses[:verified])
end
2.times do
  Recipient.create!(phone: Helper.new.format(Faker::PhoneNumber.phone_number),
                    status: Recipient.statuses[:unverified])
end

Recipient.where(status: :verified).find_each do |r|
  MessageRecipient.create!(message: Message.first, recipient: r,
                           sid: Helper.new.fake_sid, status: MessageRecipient.statuses[:success])
end
MessageRecipient.create!(message: Message.first, recipient: create(:recipient),
                         sid: Helper.new.fake_sid, status: MessageRecipient.statuses[:failure])
MessageRecipient.create!(message: Message.last, recipient: create(:recipient),
                         sid: Helper.new.fake_sid, status: MessageRecipient.statuses[:pending])
