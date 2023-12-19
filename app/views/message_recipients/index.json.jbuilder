# frozen_string_literal: true

json.array! @message_recipients, partial: 'message_recipients/message_recipient', as: :message_recipient
