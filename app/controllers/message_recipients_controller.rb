# frozen_string_literal: true

# join table for messages and recipients
class MessageRecipientsController < ApplicationController
  before_action :set_message_recipient, only: %i[show]

  # GET /message_recipients or /message_recipients.json
  def index
    @message_recipients = MessageRecipient.all
  end

  # GET /message_recipients/1 or /message_recipients/1.json
  def show; end

  # GET /message_recipients/1/edit
  def edit; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message_recipient
    @message_recipient = MessageRecipient.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def message_recipient_params
    params.require(:message_recipient).permit(:status, :error, :sid, :message_id, :recipient_id)
  end
end
