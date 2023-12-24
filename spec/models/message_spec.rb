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

  describe 'validate_sendable' do
    it 'is valid with recipients' do
      message = create(:message)
      expect(message).to be_valid
      expect(message.list_recipients.count).to be(2)

      expect(message.validate_sendable).to be_truthy
      expect(message.errors).to be_empty
    end

    describe 'invalid when no recipients' do
      let(:message) { described_class.new(content: 'No recipient lists', user: create(:user), status: :unsent) }

      it 'because no associated recipient lists' do
        expect(message).to be_valid

        expect(message.validate_sendable).not_to be_truthy
        expect(message.errors.full_messages.first).to include('No recipients associated with message')
      end

      it 'because associated recipient lists have no recipients' do
        message.recipient_lists = [create(:recipient_list, recipients: [])]
        expect(message).to be_valid

        expect(message.validate_sendable).not_to be_truthy
        expect(message.errors.full_messages.first).to include('No recipients associated with message')
      end
    end
  end
end
