# frozen_string_literal: true

class ApplicationController < ActionController::Base
  require 'will_paginate/array'
  # Ensure that CanCanCan is correctly configured
  # and authorising actions on each controller
  # check_authorization

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :update_headers_to_disable_caching
  before_action :ie_warning

  ## The following are used by our Responder service classes so we can access
  ## the instance variable for the current resource easily via a standard method
  def resource_name
    controller_name.demodulize.singularize
  end

  def current_resource
    instance_variable_get(:"@#{resource_name}")
  end

  def current_resource=(val)
    instance_variable_set(:"@#{resource_name}", val)
  end

  # Catch NotFound exceptions and handle them neatly, when URLs are mistyped or mislinked
  rescue_from ActiveRecord::RecordNotFound do
    render template: 'errors/error_404', status: 404
  end
  rescue_from CanCan::AccessDenied do
    render template: 'errors/error_403', status: 403
  end

  # IE over HTTPS will not download if browser caching is off, so allow browser caching when sending files
  def send_file(file, opts = {})
    response.headers['Cache-Control'] = 'private, proxy-revalidate' # Still prevent proxy caching
    response.headers['Pragma'] = 'cache'
    response.headers['Expires'] = '0'
    super(file, opts)
  end

  # Devise check if current user is admin?
  helper_method :current_user_admin?
  def current_user_admin?
    current_user && current_user.account_type == 'admin'
  end

  # Devise check if current user is premium?
  helper_method :current_user_premium?
  def current_user_premium?
    current_user && current_user.account_type == 'Pro'
  enddef admin_only
      unless current_user_admin?
        redirect_to '/', :alert => "Access denied."
      end
    end

  # Devise param permissions
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = %i[name email account_type password password_confirmation current_password]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update_without_password, keys: attributes)
    devise_parameter_sanitizer.permit(:update, keys: attributes)
  end

  private

  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end

  def ie_warning
    if request.user_agent.to_s =~ /MSIE [6-7]/ && request.user_agent.to_s !~ %r{Trident/7.0}
      redirect_to(ie_warning_path)
    end
  end

  def current_visit
    current_ip = request_ip
    location = Geocoder.search(current_ip).first.country
    @current_visit = Visit.find_by(id: session[:current_visit_id]) || Visit.create(location: location)
    session[:current_visit_id] = @current_visit.id
    @current_visit
  end

  def request_ip
    if Rails.env.development? || Rails.env.test?
      # Hard code remote ip for developmentr
      '123.45.67.89'
    else
      request.remote_ip
    end
  end
end
