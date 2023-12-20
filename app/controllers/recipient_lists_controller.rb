# frozen_string_literal: true

# Recipient Lists
class RecipientListsController < ApplicationController
  before_action :set_recipient_list, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /recipient_lists or /recipient_lists.json
  def index
    @recipient_lists = RecipientList.all
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
  def create # rubocop:disable Metrics/MethodLength
    @recipient_list = RecipientList.new(recipient_list_params)

    respond_to do |format|
      if @recipient_list.save
        format.html do
          redirect_to recipient_list_url(@recipient_list), notice: 'Recipient list was successfully created.'
        end
        format.json { render :show, status: :created, location: @recipient_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipient_lists/1 or /recipient_lists/1.json
  def update # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if @recipient_list.update(recipient_list_params)
        format.html do
          redirect_to recipient_list_url(@recipient_list), notice: 'Recipient list was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @recipient_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipient_lists/1 or /recipient_lists/1.json
  def destroy
    @recipient_list.destroy!

    respond_to do |format|
      format.html { redirect_to recipient_lists_url, notice: 'Recipient list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipient_list
    @recipient_list = RecipientList.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipient_list_params
    params.require(:recipient_list).permit(:name, :user_id)
  end
end
