# frozen_string_literal: true

# Message Recipient
class MessageRecipient < ApplicationRecord
  # https://www.twilio.com/docs/messaging/guides/outbound-message-status-in-status-callbacks
  enum :status, {
    pending: 'pending', # pre-Twilio
    queued: 'queued',
    canceled: 'canceled',
    sent: 'sent',
    failed: 'failed',
    delivered: 'delivered',
    undelivered: 'undelivered',
    read: 'read'
  }

  belongs_to :message
  belongs_to :recipient
  validates :status, presence: true
end
