# frozen_string_literal: true

# Recipient List
class RecipientList < ApplicationRecord
  belongs_to :user
  has_many :recipients_recipient_lists, dependent: :destroy
  has_many :recipients, through: :recipients_recipient_lists
  validates :name, presence: true
end
