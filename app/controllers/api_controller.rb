class ApiController < ActionController::Base
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session
  respond_to :json

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Content-Type, Access-Control-Allow-Headers, X-Requested-With, X-Prototype-Version, Authorization, Token'

      headers['Access-Control-Max-Age'] = '1728000'

      render :text => ''
    end
  end

end
