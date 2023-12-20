# frozen_string_literal: true

# SMS Message
class Message < ApplicationRecord
  enum :status, { unsent: 'unsent', scheduled: 'scheduled', sent: 'sent' }

  belongs_to :user
  has_many :message_recipients, dependent: :destroy
  has_many :recipients, through: :message_recipients
  validates :content, presence: true
  validates :status, presence: true
end
