# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/messages' do
  let(:user) { create(:user) }
  # This should return the minimal set of attributes required to create a valid
  # Message. As you add validations to Message, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { content: 'Park activities this month', status: :scheduled, user_id: user.id }
  end

  let(:valid_create_attributes) { { content: 'Park activities this month' } }

  let(:invalid_attributes) do
    { status: nil }
  end

  let(:message) { create(:sent_message, user:) }

  describe 'not signed in' do
    describe 'GET /index' do
      it 'redirects' do
        get messages_url
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /show' do
      it 'redirects' do
        get message_url(message)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /new' do
      it 'redirects' do
        get new_message_url
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /edit' do
      it 'redirects' do
        get edit_message_url(message)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      it 'does not create a new Message' do
        expect do
          post messages_url, params: { message: valid_create_attributes }
          expect(response).to have_http_status(:found)
          expect(response).not_to be_successful
        end.not_to change(Message, :count)
      end
    end

    describe 'POST /send' do
      it 'does not send the Message' do
        message = create(:message)

        expect do
          post send_message_url(message)
          expect(response).to have_http_status(:found)
          expect(response).not_to be_successful
          expect(message.status).to eq(Message.statuses[:scheduled])
        end.not_to change(MessageRecipient, :count)
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { content: 'Updated content', status: :scheduled, user_id: user.id }
        end

        it 'does not update the requested message' do
          patch message_url(message), params: { message: new_attributes }
          message.reload
          expect(message.content).not_to eq(new_attributes[:content])
          expect(response).not_to redirect_to(message_url(message))
          expect(response).to have_http_status(:found)
          expect(response).not_to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:message) { create(:message, user:) }

      it 'does not destroy the requested message' do
        expect do
          delete message_url(message)
        end.not_to change(Message, :count)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end
  end

  describe 'signed in user' do
    before { sign_in user }

    describe 'GET /index' do
      it 'renders a successful response' do
        get messages_url
        expect(response).to be_successful
      end

      it 'only lists records owned by current user' do
        user = create(:user_with_artifacts)
        sign_in(user)
        included = Message.where(user:).pluck(:content)
        excluded = Message.where.not(user:).pluck(:content)

        get messages_url

        expect(response).to be_successful
        included.each { |c| expect(response.body).to include(c) }
        excluded.each { |c| expect(response.body).not_to include(c) }
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        sign_in(message.user)
        get message_url(message)
        expect(response).to be_successful
      end

      it 'only shows records owned by current user' do
        user = create(:user_with_artifacts)
        sign_in(user)
        included = Message.where(user:)
        excluded = Message.where.not(user:)

        included.each do |m|
          get message_url(m)
          expect(response.body).to include(m.content)
        end

        excluded.each do |m|
          get message_url(m)
          expect(response).not_to be_successful
        end
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_message_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders a successful response' do
        get edit_message_url(message)
        expect(response).to be_successful
      end

      it 'only edits records owned by current user' do
        user = create(:user_with_artifacts)
        sign_in(user)
        included = Message.where(user:)
        excluded = Message.where.not(user:)

        included.each do |m|
          get edit_message_url(m)
          expect(response.body).to include(m.content)
        end

        excluded.each do |m|
          get edit_message_url(m)
          expect(response).not_to be_successful
        end
      end
    end

    describe 'POST /send' do
      describe 'with valid message' do
        it 'sends the Message' do
          allow_any_instance_of(TwilioClient).to receive(:send_single) { # rubocop:disable RSpec/AnyInstance
                                                   Helper.fake_twilio_send(:queued, Helper.fake_sid)
                                                 }
          message = create(:message, user:)

          expect do
            post send_message_url(message)
            message.reload
            expect(message.status).to eq(Message.statuses[:sent])
          end.to change(MessageRecipient, :count).by(message.list_recipients.count)
        end

        it 'does not send the Message if another user owns it' do
          allow_any_instance_of(TwilioClient).to receive(:send_single) { # rubocop:disable RSpec/AnyInstance
                                                   Helper.fake_twilio_send(:queued, Helper.fake_sid)
                                                 }
          message = create(:message)
          user = create(:user)
          sign_in(user)

          expect do
            post send_message_url(message)
            expect(response).to have_http_status(:unprocessable_entity)
            message.reload
            expect(message.status).to eq(Message.statuses[:scheduled])
          end.not_to change(MessageRecipient, :count)
        end
      end

      describe 'with message that cannot be sent' do
        it 'does not send the Message without recipients' do
          message = create(:message, recipient_lists: [])

          expect do
            post send_message_url(message)
            expect(response).to have_http_status(:unprocessable_entity)
            message.reload
            expect(message.status).to eq(Message.statuses[:scheduled])
          end.not_to change(MessageRecipient, :count)
        end
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Message' do
          expect do
            post messages_url, params: { message: valid_create_attributes }
          end.to change(Message, :count).by(1)
        end

        it 'creates a new Message with recipient_lists' do
          recipient_list = create(:recipient_list)
          rli = { recipient_list_ids: [recipient_list.id] }
          expect do
            expect do
              post messages_url, params: { message: valid_create_attributes.merge(rli) }
            end.to change(Message, :count).by(1)
          end.to change(MessageRecipientList, :count).by(1)
        end

        it 'redirects to the created message' do
          post messages_url, params: { message: valid_attributes }
          expect(response).to redirect_to(message_url(Message.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Message' do
          expect do
            post messages_url, params: { message: invalid_attributes }
          end.not_to change(Message, :count)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post messages_url, params: { message: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { content: 'Updated content', status: :scheduled, user_id: user.id }
        end

        it 'updates the requested message' do
          patch message_url(message), params: { message: new_attributes }
          message.reload
          expect(message.content).to eq(new_attributes[:content])
          expect(response).to redirect_to(message_url(message))
        end

        it "does not update others' message" do
          user = create(:user)
          sign_in(user)
          old_content = message.content

          patch message_url(message), params: { message: new_attributes }

          message.reload
          expect(message.content).not_to eq(new_attributes[:content])
          expect(message.content).to eq(old_content)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with invalid parameters' do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          patch message_url(message), params: { message: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:message) { create(:message, user:) }

      it 'destroys the requested message' do
        expect do
          delete message_url(message)
        end.to change(Message, :count).by(-1)
        expect(response).to redirect_to(messages_url)
      end

      it 'does not destroy message owned by another' do
        user = create(:user)
        sign_in(user)

        expect do
          delete message_url(message)
        end.not_to change(Message, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
