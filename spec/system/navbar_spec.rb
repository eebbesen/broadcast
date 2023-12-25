# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RecipientLists' do
  describe 'devise' do
    let(:password) { 'S3kr!T%' }
    let(:user) { create(:user, password:) }

    it 'sign in works' do
      visit(root_path)
      expect(page).to have_current_path(new_user_session_path)

      fill_in('Email', with: user.email)
      fill_in('Password', with: password)
      click_button 'Log in'

      expect(page).to have_current_path(root_path)
      expect(page).to have_button('Sign Out')
      expect(page).to have_content('Signed in successfully.')
    end

    it 'sign out works' do
      sign_in(user)
      visit(root_path)

      expect(page).to have_current_path(root_path)
      click_button 'Sign Out'

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  describe 'navbar' do
    before do
      sign_in(create(:user))
      visit(root_path)
    end

    describe('dropdown') do
      it 'toggles on click', :js do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_content('Navigate')
        click_button('Navigate')
        click_link('Recipient Lists')
        expect(page).not_to have_link('Recipients')
        expect(page).not_to have_link('Messages')

        click_button('Navigate')
        expect(page).to have_content('Recipient Lists')
        expect(page).to have_content('Recipients')
        expect(page).to have_content('Messages')

        click_button('Navigate')
        expect(page).not_to have_content('Recipient Lists')
        expect(page).not_to have_content('Messages')
      end

      it 'contents navigate properly', :js do
        click_button('Navigate')
        click_link('Messages')
        expect(page).to have_current_path(messages_path)

        click_button('Navigate')
        click_link('Recipients')
        expect(page).to have_current_path(recipients_path)

        click_button('Navigate')
        click_link('Recipient Lists')
        expect(page).to have_current_path(recipient_lists_path)
      end
    end
  end
end
