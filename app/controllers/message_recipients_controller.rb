# frozen_string_literal: true

# join table for messages and recipients
class MessageRecipientsController < ApplicationController
  before_action :set_message_recipient, only: :show
  before_action :authenticate_user!

  # GET /message_recipients or /message_recipients.json
  def index
    @message_recipients = MessageRecipient.all
  end

  # GET /message_recipients/1 or /message_recipients/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message_recipient
    @message_recipient = MessageRecipient.find(params[:id])
  end
end
