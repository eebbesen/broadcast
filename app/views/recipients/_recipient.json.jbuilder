# frozen_string_literal: true

json.extract! recipient, :id, :phone, :status, :created_at, :updated_at
json.url recipient_url(recipient, format: :json)
