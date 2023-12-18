# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipient do
  describe 'validates' do
    it { is_expected.to validate_presence_of :phone }
    it { is_expected.to validate_presence_of :status }
  end
end
