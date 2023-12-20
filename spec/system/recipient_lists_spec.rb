# rubocop:disable RSpec/MultipleExpectations
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RecipientLists' do
  before do
    driven_by(:rack_test)
  end

  describe 'create recipient list' do
    it 'flows properly' do
      sign_in(create(:user))
      new_user_email = 'test@you.you'

      visit recipient_lists_path
      expect(page).to have_current_path('/recipient_lists', ignore_query: true)
      click_link 'New Recipient List'

      expect(page).to have_current_path('/recipient_lists/new', ignore_query: true)
      fill_in 'Name', with: new_user_email
      click_button 'Save'

      expect(page).to have_current_path("/recipient_lists/#{RecipientList.last.id}", ignore_query: true)
      expect(page).to have_content('Recipient list was successfully created.')
      expect(page).to have_content(new_user_email)
      click_link 'Back'

      expect(page).to have_current_path('/recipient_lists', ignore_query: true)
      expect(page).to have_content(new_user_email)
    end
  end
end

# rubocop:enable RSpec/MultipleExpectations
