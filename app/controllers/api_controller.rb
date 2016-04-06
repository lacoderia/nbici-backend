class ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions
  #skip_before_filter :verify_authenticity_token
  #protect_from_forgery with: :null_session
  respond_to :json

  def self.validate_user user_id, current_user
    if user_id.to_i != current_user.id
      raise "Usuario de sesión es diferente a usuario de llamada."
    end
  end
end
