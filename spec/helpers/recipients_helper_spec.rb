# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RecipientsHelper. For example:
#
# describe RecipientsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe RecipientsHelper do
  describe 'format' do
    it 'removes +1' do
      expect(format('+16515551212')).to eq('6515551212')
    end

    it 'removes US country code' do
      expect(format('16515551212')).to eq('6515551212')
    end

    it 'does not remove US country code if significant' do
      expect(format('1651555121')).to eq('1651555121')
    end

    it 'removes dots, dashes, parenthesis and spaces' do
      expect(format('+1 (651) 555-1212')).to eq('6515551212')
      expect(format('651.555.1212')).to eq('6515551212')
    end

    it 'removes extensinos' do
      expect(format('1651555121x123')).to eq('1651555121')
    end
  end
end
