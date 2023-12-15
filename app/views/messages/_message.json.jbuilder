# frozen_string_literal: true

json.extract! message, :id, :content, :status, :sent_at, :user_id, :created_at, :updated_at
json.url message_url(message, format: :json)
