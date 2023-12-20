# frozen_string_literal: true

# Recipient List
class RecipientList < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
end
