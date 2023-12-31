# frozen_string_literal: true

# Recipients Controller
class RecipientsController < ApplicationController
  include ::NewRelic::Agent::MethodTracer

  before_action :set_recipient, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /recipients or /recipients.json
  def index
    @recipients = Recipient.includes(:messages)
  end

  # GET /recipients/1 or /recipients/1.json
  def show; end

  # GET /recipients/new
  def new
    @recipient = Recipient.new
  end

  # GET /recipients/1/edit
  def edit; end

  # POST /recipients or /recipients.json
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    log_request(__callee__, params.merge({ user_id: current_user.id }))
    @recipient = Recipient.new(recipient_params.merge(status: :unverified))

    respond_to do |format|
      if @recipient.save
        log_success(__callee__, params.merge({ user_id: current_user.id }))
        format.html { redirect_to recipient_url(@recipient), notice: 'Recipient was successfully created.' }
        format.json { render :show, status: :created, location: @recipient }
      else
        log_failure(__callee__, params.merge({ user_id: current_user.id }))
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipients/1 or /recipients/1.json
  def update # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    respond_to do |format|
      if @recipient.update(recipient_params)
        log_success(__callee__, params.merge({ user_id: current_user.id }))
        format.html { redirect_to recipient_url(@recipient), notice: 'Recipient was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipient }
      else
        log_failure(__callee__, params.merge({ user_id: current_user.id }))
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipients/1 or /recipients/1.json
  def destroy
    @recipient.destroy!
    log_success(__callee__, params.merge({ user_id: current_user.id }))

    respond_to do |format|
      format.html { redirect_to recipients_url, notice: 'Recipient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipient
    @recipient = Recipient.includes(:messages).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipient_params
    params.require(:recipient).permit(:phone, :status)
  end

  add_method_tracer :index, 'index'
end
