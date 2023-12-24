# frozen_string_literal: true

require 'rails_helper'

TwilioReturn = Struct.new(:status, :error_message)

RSpec.describe SendStatusJob do
  it('updates status with sent') do
    sent_ret = TwilioReturn.new('sent', nil)

    allow_any_instance_of(TwilioClient).to receive(:get_status) { sent_ret } # rubocop:disable RSpec/AnyInstance

    create(:message_recipient, status: MessageRecipient.statuses[:queued])

    expect do
      described_class.new.perform
    end.to change(MessageRecipient.where(status: :sent), :count).by(1)
  end
end
