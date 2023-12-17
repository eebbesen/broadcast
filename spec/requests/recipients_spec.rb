# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/recipients' do
  # This should return the minimal set of attributes required to create a valid
  # Recipient. As you add validations to Recipient, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { phone: '6515551212', status: Recipient.statuses[:verified] } }

  let(:invalid_attributes) { { phone: nil, status: Recipient.statuses[:verified] } }

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