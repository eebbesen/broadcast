# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageRecipient do
  it { is_expected.to belong_to :message }
  it { is_expected.to belong_to :recipient }
  it { is_expected.to validate_presence_of :status }
end
