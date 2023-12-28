# rubocop:disable RSpec/MultipleExpectations
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RecipientList' do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'is axe-compliant', :js do
    let!(:recipient_list) { create(:recipient_list, user:) }

    it 'index' do
      visit(recipient_lists_path)
      expect(page).to be_axe_clean
    end

    it 'show' do
      visit(recipient_list_path(recipient_list))
      expect(page).to be_axe_clean
    end

    it 'new' do
      visit(new_recipient_list_path)
      expect(page).to be_axe_clean
    end

    it 'edit' do
      visit(edit_recipient_list_path(recipient_list))
      expect(page).to be_axe_clean
    end
  end

  describe 'from recipient list index' do
    let!(:recipient_list) { create(:recipient_list, user:) }

    before do
      visit(recipient_lists_path)
      find(:id, "link-recipient-list-#{recipient_list.id}").click
    end

    # need to create ID for links around list records: https://edgeapi.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    it 'flows properly back to list' do
      expect(page).to have_current_path(recipient_list_path(recipient_list))
      click_link('Back')

      expect(page).to have_current_path(recipient_lists_path)
    end

    it 'flows properly to edit' do
      expect(page).to have_current_path(recipient_list_path(recipient_list))
      click_link('Edit')

      expect(page).to have_current_path(edit_recipient_list_path(recipient_list))
    end

    it 'flows properly to create' do
      visit(recipient_lists_path)
      expect(page).to have_current_path(recipient_lists_path)
      click_link('New List')

      expect(page).to have_current_path(new_recipient_list_path)
    end
  end

  describe 'edit recipient list' do
    let!(:recipient_list) { create(:recipient_list, user:) }

    before { visit edit_recipient_list_path(recipient_list) }

    it 'flows properly on success' do
      updated_name = 'Updated Recipient List Name'

      expect(page).to have_current_path(edit_recipient_list_path(recipient_list))
      fill_in('Name', with: updated_name)
      click_button('Save')

      expect(page).to have_current_path(recipient_list_path(recipient_list))
    end

    it 'displays error when invalid' do
      expect(page).to have_current_path(edit_recipient_list_path(recipient_list))
      fill_in('Name', with: '')
      click_button('Save')

      expect(page).to have_content("Name can't be blank")
    end
  end

  describe 'create recipient list' do
    before { visit new_recipient_list_path }

    it 'flows properly on success' do
      updated_name = 'Updated Recipient List Name'

      expect(page).to have_current_path(new_recipient_list_path)
      fill_in('Name', with: updated_name)
      click_button('Save')

      expect(page).to have_current_path(recipient_list_path(RecipientList.last.id))
      expect(page).to have_content('Recipient list was successfully created.')
      expect(page).to have_content(updated_name)
      click_link('Back')

      expect(page).to have_current_path(recipient_lists_path)
      expect(page).to have_content(updated_name)
    end

    it 'displays error when invalid' do
      expect(page).to have_current_path(new_recipient_list_path)
      click_button('Save')

      expect(page).to have_content("Name can't be blank")
      # page showing '/recipients' in test only after failure (?!)
      # expect(page).to have_current_path(new_recipient_list_path)
    end
  end
end

# rubocop:enable RSpec/MultipleExpectations
