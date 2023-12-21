# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/index' do
  let(:recipient_lists) do
    [
      create(:recipient_list),
      create(:recipient_list, name: 'Snow Emergencies')
    ]
  end

  before do
    assign(:recipient_lists, recipient_lists)
  end

  it 'renders a list of recipient lists' do
    render
    %w[Name User Recipients].each { |h| expect(rendered).to include(h) }
    recipient_lists.each do |rl|
      [rl.name, rl.user.email, rl.recipients.count.to_s]
        .each { |a| expect(rendered).to include(a) }
    end
  end
end
