# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/recipients' do
  let(:user) { create(:user) }
  # This should return the minimal set of attributes required to create a valid
  # Recipient. As you add validations to Recipient, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { phone: '6515551212', status: Recipient.statuses[:verified] } }
  let(:invalid_attributes) { { phone: nil, status: Recipient.statuses[:verified] } }

  describe 'not signed in' do
    describe 'GET /index' do
      it 'redirects' do
        Recipient.create! valid_attributes
        get recipients_url
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /show' do
      it 'redirects' do
        recipient = Recipient.create! valid_attributes
        get recipient_url(recipient)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /new' do
      it 'redirects' do
        get new_recipient_url
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'GET /edit' do
      it 'redirects' do
        recipient = Recipient.create! valid_attributes
        get edit_recipient_url(recipient)
        expect(response).to have_http_status(:found)
        expect(response).not_to be_successful
      end
    end

    describe 'POST /create' do
      it 'does not create a new Recipient' do
        expect do
          post recipients_url, params: { recipient: valid_attributes }
          expect(response).to have_http_status(:found)
          expect(response).not_to be_successful
        end.not_to change(Recipient, :count)
      end
    end

    describe 'PATCH /update' do
      let(:new_attributes) { { status: Recipient.statuses[:blocked] } }

      it 'does not update the requested recipient' do
        recipient = Recipient.create! valid_attributes
        patch recipient_url(recipient), params: { recipient: new_attributes }
        recipient.reload
        expect(response).not_to be_successful
        expect(recipient.status).to eq(valid_attributes[:status])
      end
    end

    describe 'DELETE /destroy' do
      it 'does not destroy the requested recipient' do
        recipient = Recipient.create! valid_attributes
        expect do
          delete recipient_url(recipient)
        end.not_to change(Recipient, :count)
      end
    end
  end

  describe 'with signed in user' do
    before { sign_in user }

    describe 'GET /index' do
      it 'renders a successful response' do
        Recipient.create! valid_attributes
        get recipients_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        recipient = Recipient.create! valid_attributes
        get recipient_url(recipient)
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_recipient_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'renders a successful response' do
        recipient = Recipient.create! valid_attributes
        get edit_recipient_url(recipient)
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Recipient' do
          expect do
            post recipients_url, params: { recipient: valid_attributes }
          end.to change(Recipient, :count).by(1)
        end

        it 'redirects to the created recipient' do
          post recipients_url, params: { recipient: valid_attributes }
          expect(response).to redirect_to(recipient_url(Recipient.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Recipient' do
          expect do
            post recipients_url, params: { recipient: invalid_attributes }
          end.not_to change(Recipient, :count)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post recipients_url, params: { recipient: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) { { status: Recipient.statuses[:blocked] } }

        it 'updates the requested recipient' do
          recipient = Recipient.create! valid_attributes
          patch recipient_url(recipient), params: { recipient: new_attributes }
          recipient.reload
          expect(recipient.status).to eq(Recipient.statuses[:blocked])
        end

        it 'redirects to the recipient' do
          recipient = Recipient.create! valid_attributes
          patch recipient_url(recipient), params: { recipient: new_attributes }
          recipient.reload
          expect(response).to redirect_to(recipient_url(recipient))
        end
      end

      context 'with invalid parameters' do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          recipient = Recipient.create! valid_attributes
          patch recipient_url(recipient), params: { recipient: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested recipient' do
        recipient = Recipient.create! valid_attributes
        expect do
          delete recipient_url(recipient)
        end.to change(Recipient, :count).by(-1)
      end

      it 'redirects to the recipients list' do
        recipient = Recipient.create! valid_attributes
        delete recipient_url(recipient)
        expect(response).to redirect_to(recipients_url)
      end
    end
  end
end
