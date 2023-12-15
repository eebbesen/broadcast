# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  describe 'validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_presence_of :status }
  end
end
