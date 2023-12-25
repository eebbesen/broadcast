# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/show' do
  it 'renders attributes for sent message' do # rubocop:disable RSpec/MultipleExpectations
    message = create(:sent_message)
    assign(:message, message)

    render

    ['Content', 'Status', 'Sent At', 'Recipient Lists', 'Recipients']
      .each { |h| expect(rendered).to include(h) }
    [
      message.content,
      message.status.capitalize,
      ui_date(message.sent_at),
      message.message_recipients.count.to_s
    ].each { |a| expect(rendered).to include(a) }
    %w[Phone Status Error].each { |h| expect(rendered).to include(h) }
    message.message_recipients.each do |mr|
      [mr.recipient.phone, mr.status].each { |a| expect(rendered).to include(a) }
      expect(rendered).not_to include('Send')
      expect(rendered).not_to include('Delete')
      expect(rendered).not_to include('Edit')
    end
  end

  it 'renders attributes for failed message' do
    message = create(:failed_message)
    assign(:message, message)

    render

    ['Content', 'Status', 'Recipient Lists', 'Recipients']
      .each { |h| expect(rendered).to include(h) }
    [
      message.content,
      message.status.capitalize
    ].each { |a| expect(rendered).to include(a) }
    %w[Phone Status Error Send Edit].each { |h| expect(rendered).to include(h) }
    message.message_recipients.each do |mr|
      [mr.recipient.phone, mr.status, mr.error].each { |a| expect(rendered).to include(a) }
      expect(rendered).not_to include('Delete')
    end
  end

  it 'renders attributes for unsent message' do
    message = create(:message)
    assign(:message, message)

    render

    ['Content', 'Status', 'Recipient Lists', 'Estimated Recipients']
      .each { |h| expect(rendered).to include(h) }
    [
      message.content,
      message.status.capitalize,
      message.message_recipients.count.to_s
    ].each { |a| expect(rendered).to include(a) }
    %w[Phone Status Send Edit Delete].each { |h| expect(rendered).to include(h) }
    message.message_recipients.each do |mr|
      [mr.recipient.phone, mr.status].each { |a| expect(rendered).to include(a) }
    end
  end
end
