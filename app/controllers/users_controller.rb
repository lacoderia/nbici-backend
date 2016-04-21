class UsersController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!
  
  before_action :set_user, only: [:show, :update, :destroy]

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      if user_params[:password]
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        sign_in(@user)
      end
      render json: @user
    else
      render json: ErrorSerializer.serialize(@user.errors)
    end
  end

  private

    def set_user
      begin
        @user = User.find(params[:id])
      rescue Exception => e
        @user = User.new
        @user.errors.add(:not_found, "Usuario no encontrado.")
        render json: ErrorSerializer.serialize(@user.errors), status: 500
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :classes_left, :last_class_purchased, :picture, :uid, :active, :password, :password_confirmation)
    end
end
