# rubocop:disable RSpec/MultipleExpectations
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipient' do
  before { sign_in(create(:user)) }

  describe 'from recipient index' do
    let!(:recipient) { create(:recipient) }

    before do
      visit(recipients_path)
      find(:id, "link-recipient-#{recipient.id}").click
    end

    # need to create ID for links around records: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    it 'flows properly back to list' do
      expect(page).to have_current_path(recipient_path(recipient))
      click_link('Back')

      expect(page).to have_current_path(recipients_path)
    end

    it 'flows properly to create' do
      visit(recipients_path)
      expect(page).to have_current_path(recipients_path)
      click_link('New Recipient')

      expect(page).to have_current_path(new_recipient_path)
    end
  end

  describe 'create recipient' do
    before { visit new_recipient_path }

    it 'flows properly on success' do
      updated_phone = '0000000000'

      expect(page).to have_current_path(new_recipient_path)
      fill_in('Phone', with: updated_phone)
      click_button('Save')

      expect(page).to have_current_path(recipient_path(Recipient.last.id))
      expect(page).to have_content('Recipient was successfully created.')
      expect(page).to have_content(updated_phone)
      click_link('Back')

      expect(page).to have_current_path(recipients_path)
      expect(page).to have_content(updated_phone)
    end

    it 'displays error when invalid' do
      expect(page).to have_current_path(new_recipient_path)
      click_button('Save')

      expect(page).to have_content("Phone can't be blank")
      # page showing '/recipients' in test only after failure (?!)
      # expect(page).to have_current_path(new_recipient_path)
    end
  end
end

# rubocop:enable RSpec/MultipleExpectations
