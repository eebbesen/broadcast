# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipientsRecipientList do
  describe 'validations' do
    it { is_expected.to belong_to :recipient }
    it { is_expected.to belong_to :recipient_list }
  end
end
