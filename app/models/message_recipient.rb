# frozen_string_literal: true

# Message Recipient
class MessageRecipient < ApplicationRecord
  enum :status, { pending: 'pending', success: 'success', failure: 'failure' }

  belongs_to :message
  belongs_to :recipient
  validates :status, presence: true
end
