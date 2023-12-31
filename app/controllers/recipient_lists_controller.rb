# frozen_string_literal: true

# Recipient Lists
class RecipientListsController < ApplicationController
  include ::NewRelic::Agent::MethodTracer

  before_action :set_recipient_list, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /recipient_lists or /recipient_lists.json
  def index
    @recipient_lists = RecipientList.where(user: current_user).includes(:recipients_recipient_lists)
  end

  # GET /recipient_lists/1 or /recipient_lists/1.json
  def show; end

  # GET /recipient_lists/new
  def new
    @recipient_list = RecipientList.new
  end

  # GET /recipient_lists/1/edit
  def edit; end

  # POST /recipient_lists or /recipient_lists.json
  def create # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    log_request(__callee__, params.merge({ user_id: current_user.id }))
    @recipient_list = RecipientList.new(recipient_list_params.merge(user: current_user))

    respond_to do |format|
      if @recipient_list.save
        log_success(__callee__, params.merge({ user_id: current_user.id }))
        format.html do
          redirect_to recipient_list_url(@recipient_list), notice: 'Recipient list was successfully created.'
        end
        format.json { render :show, status: :created, location: @recipient_list }
      else
        log_failure(__callee__, params.merge({ user_id: current_user.id }))
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipient_lists/1 or /recipient_lists/1.json
  def update # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    respond_to do |format|
      log_request(__callee__, params.merge({ user_id: current_user.id }))
      if @recipient_list.update(recipient_list_params)
        log_success(__callee__, params.merge({ user_id: current_user.id }))
        format.html do
          redirect_to recipient_list_url(@recipient_list), notice: 'Recipient list was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @recipient_list }
      else
        log_failure(__callee__, params.merge({ user_id: current_user.id }))
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipient_lists/1 or /recipient_lists/1.json
  def destroy
    @recipient_list.destroy!
    log_success(__callee__, params.merge({ user_id: current_user.id }))

    respond_to do |format|
      format.html { redirect_to recipient_lists_url, notice: 'Recipient list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipient_list
    return unless current_user

    @recipient_list = RecipientList.where(user: current_user).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipient_list_params
    params.require(:recipient_list).permit(:name, :user_id)
  end

  add_method_tracer :index, 'index'
end
