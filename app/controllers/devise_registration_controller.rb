# app/controllers/registrations_controller.rb
class DeviseRegistrationController < Devise::RegistrationsController



  protected

  def build_resource(params = nil)
    if params != nil
      if params[:account_type] != AccountType::PREMIUM && params[:account_type] != AccountType::FREE && params[:account_type] != AccountType::STUDENT
        params[:account_type] = AccountType::FREE
      end
    end
    super
  end

  def update_resource(resource, params)
    if params[:account_type] != AccountType::PREMIUM && params[:account_type] != AccountType::FREE && params[:account_type] != AccountType::STUDENT
      params[:account_type] = AccountType::FREE
    end
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
  end
end
