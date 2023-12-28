# frozen_string_literal: true

# Messages Controller
class MessagesController < ApplicationController
  include ::NewRelic::Agent::MethodTracer

  before_action :set_message, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /messages or /messages.json
  def index
    return unless current_user

    Rollbar.info("Home page accessed by #{current_user.id}")

    @messages = Message.where(user: current_user).includes(:recipients)
  end

  # GET /messages/1 or /messages/1.json
  def show; end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit; end

  # POST /messages/1/send
  # just naming this 'send' appears to conflict with existing method
  # todo: work on integrating this into the before action -- need to capture and handle
  #  ActiveRecord::RecordNotFound exception like built-ins methods do
  def send_message # rubocop:disable Metrics/AbcSize
    log_request(__callee__, params.merge({ user_id: current_user.id }))

    begin
      set_message
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("User #{current_user.id} attempted to send message #{params[:id]}")
    end

    respond_to do |format|
      if @message && MessageService.new.send_message(@message)
        log_success(__callee__, params.merge({ user_id: current_user.id }))
        format.html { redirect_to message_url(@message), notice: 'Message sent.' }
        format.json { render :show, status: :created, location: @message }
      else
        log_failure(__callee__, params.merge({ user_id: current_user.id }))
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /messages or /messages.json
  def create # rubocop:disable Metrics/AbcSize
    @message = Message.new(message_params.merge(status: :unsent, user: current_user))

    respond_to do |format|
      log_request(__callee__, params.merge({ user_id: current_user.id }))
      if @message.save
        log_success(__callee__, params.merge({ user_id: current_user.id }))
        format.html { redirect_to message_url(@message), notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        log_failure(__callee__, params.merge({ user_id: current_user.id }))
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update # rubocop:disable Metrics/AbcSize
    log_request(__callee__, params.merge({ user_id: current_user.id }))
    respond_to do |format|
      if @message.update(message_params)
        log_success(__callee__, params.merge({ user_id: current_user.id }))
        format.html { redirect_to message_url(@message), notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        log_failure(__callee__, params.merge({ user_id: current_user.id }))
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!
    log_success(__callee__, params.merge({ user_id: current_user.id }))

    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    return unless current_user

    @message = Message.where(user: current_user).includes(:recipients).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:content, :status, :user_id, recipient_list_ids: [])
  end

  add_method_tracer :send_message, 'send_message'
  add_method_tracer :index, 'index'
end
