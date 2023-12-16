# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin do
  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
  end
end
