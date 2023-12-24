# frozen_string_literal: true

# Retrieve status updates from Twilio
class SendStatusJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    MessageRecipient.queued.each do |mr|
      MessageService.new.update_recipient_status(mr)
    end
  end
end
