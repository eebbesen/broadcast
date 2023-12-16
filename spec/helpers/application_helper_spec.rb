# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesHelper do
  let(:helper) { TestAH.new}

  describe 'ui_date' do
    it 'handles empty input' do
      expect(helper.ui_date(nil)).to equal('')
    end

    it 'formats date' do
      d = DateTime.new(2023, 12, 16, 14, 20, 23)
      expect(helper.ui_date(d)).to eq('Sat 12/16/2023 02:20 PM')
    end
  end
end

class TestAH
  include ApplicationHelper
end