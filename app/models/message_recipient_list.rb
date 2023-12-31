# frozen_string_literal: true

# Join Messages and Recipient Lists
class MessageRecipientList < ApplicationRecord
  belongs_to :message
  belongs_to :recipient_list
end
