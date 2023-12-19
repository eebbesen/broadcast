# frozen_string_literal: true

# Recipient
class Recipient < ApplicationRecord
  enum :status, { unverified: 'unverified', verified: 'verified', blocked: 'blocked' }

  has_many :message_recipients, dependent: :destroy
  validates :phone, presence: true
  validates :status, presence: true
end
