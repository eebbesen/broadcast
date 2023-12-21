# frozen_string_literal: true

# Recipient
class Recipient < ApplicationRecord
  enum :status, { unverified: 'unverified', verified: 'verified', blocked: 'blocked' }

  has_many :message_recipients, dependent: :destroy
  has_many :messages, through: :message_recipients
  has_many :recipients_recipient_lists, dependent: :destroy
  has_many :recipient_lists, through: :recipients_recipient_lists
  validates :phone, presence: true
  validates :status, presence: true
end
