# frozen_string_literal: true

# SMS Message
class Message < ApplicationRecord
  enum :status, { unsent: 'unsent', scheduled: 'scheduled', sent: 'sent' }

  belongs_to :user
  has_many :message_recipients, dependent: :destroy
  has_many :message_recipient_lists, dependent: :destroy
  has_many :recipients, through: :message_recipients
  has_many :recipient_lists, through: :message_recipient_lists
  validates :content, presence: true
  validates :status, presence: true
end
