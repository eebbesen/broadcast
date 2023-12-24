# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendStatusJob do
  it('updates status with sent') do
    sent_ret = Helper.fake_twilio_status('sent', nil)

    allow_any_instance_of(TwilioClient).to receive(:get_status) { sent_ret } # rubocop:disable RSpec/AnyInstance

    create(:message_recipient, status: :queued)

    expect do
      described_class.new.perform
    end.to change(MessageRecipient.where(status: :sent), :count).by(1)
  end
end
