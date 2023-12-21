# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipientList do
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :recipients_recipient_lists }
  it { is_expected.to have_many(:recipients).through(:recipients_recipient_lists) }
  it { is_expected.to validate_presence_of :name }
end
