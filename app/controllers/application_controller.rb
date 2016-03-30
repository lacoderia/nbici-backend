class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  skip_before_filter :verify_authenticity_token
end
