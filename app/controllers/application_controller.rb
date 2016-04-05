class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  
  skip_before_filter :verify_authenticity_token
  
  respond_to :json

  #before_action :configure_permitted_parameters, if: :devise_controller?

  #protected

  #def configure_permitted_parameters
  #  devise_parameter_sanitizer.for(:sign_up) << {user: [:first_name, :last_name, :email, :password, :password_confirmation]}
  #end
  
end
