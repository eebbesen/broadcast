# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/recipient_lists' do
  let(:user) { create(:user) }
  # This should return the minimal set of attributes required to create a valid
  # RecipientList. As you add validations to RecipientList, be sure to
  # adjust the attributes here as well.
  # note that user is required but added by the controller
  let(:valid_attributes) do
    { name: 'Park Events' }
  end
  let(:invalid_attributes) { { naem: nil } }
  let!(:recipient_list) { RecipientList.create!(valid_attributes.merge(user:)) }

  describe 'signed in user' do
    before { sign_in user }

    describe 'GET /index' do
      it 'renders a successful response' do
        get recipient_lists_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
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
          { name: 'Park Events updated' }
        end

        it 'updates the requested recipient_list' do
          patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          recipient_list.reload
          expect(recipient_list.name).to eq('Park Events updated')
        end

        it 'redirects to the recipient_list' do
          patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          recipient_list.reload
          expect(response).to redirect_to(recipient_list_url(recipient_list))
        end
      end

      context 'with invalid parameters' do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          patch recipient_list_url(recipient_list), params: { recipient_list: { name: nil } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested recipient_list' do
        expect do
          delete recipient_list_url(recipient_list)
        end.to change(RecipientList, :count).by(-1)
      end

      it 'redirects to the recipient_lists list' do
        delete recipient_list_url(recipient_list)
        expect(response).to redirect_to(recipient_lists_url)
      end
    end
  end

  describe 'unauthenticated' do
    describe 'GET /index' do
      it 'renders a successful response' do
        get recipient_lists_url
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        get recipient_list_url(recipient_list)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_recipient_list_url
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders a successful response' do
        get edit_recipient_list_url(recipient_list)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new RecipientList' do
          expect do
            post recipient_lists_url, params: { recipient_list: valid_attributes }
          end.not_to change(RecipientList, :count)
          expect(response).to have_http_status(:found)
          expect(response).not_to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { name: 'Park Events updated' }
        end

        it 'updates the requested recipient_list' do
          expected = recipient_list.name
          patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          recipient_list.reload
          expect(recipient_list.name).to eq(expected)
          expect(response).to have_http_status(:found)
          expect(response).not_to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested recipient_list' do
        expect do
          delete recipient_list_url(recipient_list)
        end.not_to change(RecipientList, :count)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end
  end
end
