# frozen_string_literal: true

json.extract! recipient_list, :id, :name, :user_id, :created_at, :updated_at
json.url recipient_list_url(recipient_list, format: :json)
