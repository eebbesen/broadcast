# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  describe 'validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :message_recipients }
    it { is_expected.to have_many(:recipients).through(:message_recipients) }
    it { is_expected.to have_many(:message_recipient_lists) }
    it { is_expected.to have_many(:recipient_lists).through(:message_recipient_lists) }
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_presence_of :status }
  end

  describe 'list_recipients' do
    it 'gets recipients from lists' do
      message = create(:message)
      rls = message.recipient_lists
      expected_recipients = rls.map(&:recipients).flatten
      expect(!expected_recipients.empty?).to be_truthy

      lrs = message.list_recipients

      expect(lrs.count).to eq(expected_recipients.size)
      expected_recipients.each { |er| expect(lrs.pluck(:phone)).to include(er.phone) }
    end
  end
end
