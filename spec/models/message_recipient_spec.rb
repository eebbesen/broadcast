# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageRecipient do
  describe 'validates' do
    it { is_expected.to belong_to :message }
    it { is_expected.to belong_to :recipient }
    it { is_expected.to validate_presence_of :status }
  end

  it 'queued scope returns queued records' do
    %i[queued sent pending delivered queued]
      .each { |s| create(:message_recipient, status: s) }

    expect(described_class.queued.size).to be(2)
  end

  it 'sent scope returns queued records' do
    %i[sent sent pending sent queued]
      .each { |s| create(:message_recipient, status: s) }

    expect(described_class.sent.size).to be(3)
  end
end
