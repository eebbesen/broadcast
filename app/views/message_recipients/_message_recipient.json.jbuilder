# frozen_string_literal: true

json.extract! message_recipient, :id, :status, :error, :sid, :message_id, :recipient_id, :created_at, :updated_at
json.url message_recipient_url(message_recipient, format: :json)
