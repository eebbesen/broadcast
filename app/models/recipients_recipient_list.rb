# frozen_string_literal: true

# Join for Recipients and EecipientLists
class RecipientsRecipientList < ApplicationRecord
  belongs_to :recipient
  belongs_to :recipient_list
end
