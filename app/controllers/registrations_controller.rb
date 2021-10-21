# frozen_string_literal: true

class RegistrationsController < ApplicationController
  protect_from_forgery prepend: true, with: :exception
  before_action :set_registration, only: %i[show edit update destroy]
  # skip_before_action :verify_authenticity_token

  # GET /registrations
  def index
    @registrations = Registration.all
  end

  # GET /registrations/1
  def show; end

  # GET /registrations/new
  def new
    @registration = Registration.new
  end

  # GET /registrations/1/edit
  def edit; end

  # POST /registrations
  def create
    @registration = Registration.new(registration_params)
    return unless @registration.update(registration_params)

    current_visit.update(registration_id: @registration.id)
    session[:current_visit_id] = nil
    redirect_to :root, notice: 'Thanks for registering your interest!'
  end

  # PATCH/PUT /registrations/1
  def update
    if @registration.update(registration_params)
      redirect_to @registration, notice: 'Registration was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /registrations/1
  def destroy
    @registration.destroy
    redirect_to registrations_url, notice: 'Registration was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_registration
    @registration = Registration.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def registration_params
    # Extract auth token from submitted params
    params.extract!(:authenticity_token)
    params.permit(:email, :tier)
  end
end
