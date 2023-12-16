# frozen_string_literal: true

# SMS Message
class Message < ApplicationRecord
  enum :status, { unsent: 'unsent', scheduled: 'scheduled', sent: 'sent' }

  belongs_to :user
  validates :content, presence: true
  validates :status, presence: true
end
