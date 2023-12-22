# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:recipient_lists).dependent(:destroy) }
  end
end
