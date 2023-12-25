# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RecipientLists' do
  let(:user) { create(:user_with_artifacts) }

  describe 'signed in' do
    before { sign_in(user) }

    describe 'message sending' do
      it 'sends message' do
        allow_any_instance_of(TwilioClient).to receive(:send_single) { # rubocop:disable RSpec/AnyInstance
                                                 Helper.fake_twilio_send(:queued, Helper.fake_sid)
                                               }
        message = create(:message, status: :unsent, sent_at: nil, user:)
        expect do
          visit(messages_path)
          click_link(message.content)

          click_button('Send')
          expect(page).to have_current_path(message_path(message))
        end.to change(Message.where(status: :sent), :count).by(1)
      end
    end

    describe 'message creation' do
      before do
        visit(messages_path)
        click_link('New Message')
      end

      it 'creates message' do
        expect do
          fill_in('Content', with: 'New message text: Park updates')
          find_by_id("user_recipient_list_ids_#{user.recipient_lists.first.id}").set(true)
          click_button('Save')

          expect(page).to have_current_path(message_path(Message.last))
          expect(page).to have_content('Message was successfully created.')
        end.to change(Message, :count).by(1)
      end

      it 'does not create message without content' do
        expect do
          find_by_id("user_recipient_list_ids_#{user.recipient_lists.first.id}").set(true)
          click_button('Save')

          expect(page).to have_content("Content can't be blank")
          # page showing '/messages' in test only after failure (?!),
          #   need to learn more about how have_current_path works after a failure
          # expect(page).to have_current_path(new_message_path)
        end.not_to change(Message, :count)
      end

      it 'backs out of creation' do
        expect do
          click_link('Back')
          expect(page).to have_current_path(messages_path)
        end.not_to change(Message, :count)
      end
    end

    describe 'message editing' do
      let!(:message) { create(:message, user:) }

      before do
        sign_in(user)
        visit(messages_path)
        click_link(message.content)

        click_link('Edit')
      end

      it 'updates message' do
        updated_text = 'Message now updated'

        fill_in('Content', with: updated_text)
        click_button('Save')

        expect(page).to have_current_path(message_path(message.id))
        expect(Message.find(message.id).content).to eq(updated_text)
      end

      it 'does not update message without content' do
        content = message.content

        fill_in('Content', with: '')
        click_button('Save')

        expect(page).to have_content("Content can't be blank")
        expect(Message.find(message.id).content).to eq(content)
        # expect(page).to have_current_path(edit_message_path(message.id))
      end

      it 'backs out of edit' do
        expect do
          click_link('Back')
          expect(page).to have_current_path(message_path(message))
        end.not_to change(Message, :count)
      end
    end
  end
end
