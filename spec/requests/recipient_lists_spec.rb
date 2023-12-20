# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/recipient_lists' do
  let(:user) { create(:user) }
  # This should return the minimal set of attributes required to create a valid
  # RecipientList. As you add validations to RecipientList, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { user_id: user.id, name: 'Park Events' }
  end

  let(:invalid_attributes) { { user_id: user.id } }

  describe 'signed in user' do
    before { sign_in user }

    describe 'GET /index' do
      it 'renders a successful response' do
        RecipientList.create! valid_attributes
        get recipient_lists_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        recipient_list = RecipientList.create! valid_attributes
        get recipient_list_url(recipient_list)
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_recipient_list_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders a successful response' do
        recipient_list = RecipientList.create! valid_attributes
        get edit_recipient_list_url(recipient_list)
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new RecipientList' do
          expect do
            post recipient_lists_url, params: { recipient_list: valid_attributes }
          end.to change(RecipientList, :count).by(1)
        end

        it 'redirects to the created recipient_list' do
          post recipient_lists_url, params: { recipient_list: valid_attributes }
          expect(response).to redirect_to(recipient_list_url(RecipientList.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new RecipientList' do
          expect do
            post recipient_lists_url, params: { recipient_list: invalid_attributes }
          end.not_to change(RecipientList, :count)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post recipient_lists_url, params: { recipient_list: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { user_id: create(:user).id, name: 'Park Events updated' }
        end

        it 'updates the requested recipient_list' do
          recipient_list = RecipientList.create! valid_attributes
          patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          recipient_list.reload
          expect(recipient_list.name).to eq('Park Events updated')
        end

        it 'redirects to the recipient_list' do
          recipient_list = RecipientList.create! valid_attributes
          patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          recipient_list.reload
          expect(response).to redirect_to(recipient_list_url(recipient_list))
        end
      end

      context 'with invalid parameters' do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          recipient_list = RecipientList.create! valid_attributes
          patch recipient_list_url(recipient_list), params: { recipient_list: { user_id: nil } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested recipient_list' do
        recipient_list = RecipientList.create! valid_attributes
        expect do
          delete recipient_list_url(recipient_list)
        end.to change(RecipientList, :count).by(-1)
      end

      it 'redirects to the recipient_lists list' do
        recipient_list = RecipientList.create! valid_attributes
        delete recipient_list_url(recipient_list)
        expect(response).to redirect_to(recipient_lists_url)
      end
    end
  end
end
