# frozen_string_literal: true

# The default from number for tests is +15005550006, Twilio's "success" magic number.
# This is configured via rails_helper.rb.
# See https://www.twilio.com/docs/iam/test-credentials#test-sms-messages
# for more on testing Twilio with magic numbers.

require 'rails_helper'

RSpec.describe 'TwilioClient' do
  let(:twilio_client) { TwilioClient.new }

  describe 'format_phone' do
    it 'formats phone that needs formatting' do
      ret = TwilioClient.format_phone('5551234567')
      expect(ret).to eq('+15551234567')
    end

    it 'does not format phone that does not need formatting' do
      ret = TwilioClient.format_phone('+15551234567')
      expect(ret).to eq('+15551234567')
    end
  end

  describe 'send_single' do
    it 'sends successfully' do
      VCR.use_cassette('twilio_send_success') do
        ret = twilio_client.send_single('6515551212', "test: #{DateTime.now}")

        expect(ret.status).to eq('queued')
        expect(ret.error_message).to be_nil
      end
    end

    it 'encounters number that blocked sender' do
      VCR.use_cassette('twilio_send_blocked') do
        expect { twilio_client.send_single('5005550004', "test: #{DateTime.now}") }
          .to raise_error(Twilio::REST::RestError)
      end
    end

    it 'encounters number that cannot receive SMS' do
      VCR.use_cassette('twilio_not_mobile') do
        expect { twilio_client.send_single('5005550009', "test: #{DateTime.now}") }
          .to raise_error(Twilio::REST::RestError)
      end
    end
  end
end
