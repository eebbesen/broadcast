# frozen_string_literal: true

# SMS Message
class Message < ApplicationRecord
  enum :status, { unsent: 'unsent', scheduled: 'scheduled', sent: 'sent', failed: 'failed' }

  belongs_to :user
  has_many :message_recipients, dependent: :destroy
  has_many :message_recipient_lists, dependent: :destroy
  has_many :recipients, through: :message_recipients
  has_many :recipient_lists, through: :message_recipient_lists
  validates :content, presence: true
  validates :status, presence: true

  # At send-time recipients are taken from recipient lists.
  # This menthod references the recipient lists associated with the message
  #  to get the recipients they contain
  def list_recipients
    recipient_lists.map(&:recipients).flatten
  end

  def validate_sendable
    return true unless list_recipients.count < 1

    errors.add(:recipients, type: :invalid, message: 'No recipients associated with message')
    false
  end
end
