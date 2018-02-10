class UsersController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!
  
  before_action :set_user, only: [:update, :send_coupon_by_email]

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

  def send_coupon_by_email
    begin
      coupon = @user.send_coupon_by_email params[:email]
      render json: CouponSerializer.serialize(coupon) 
    rescue Exception => e
      errors = {:error_sending_coupon => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # Bidirectional connection between N-bici and N-box servers
  
  # CALLED FROM THE FRONT END

  # @email remote system username
  # @password remote system password
  def remote_authenticate 
    begin
      response = User.remote_authenticate params[:email], params[:password] 
      if response.code == "200" 
        session[:request_headers] = Connection.get_headers response
        render json: current_user, status: :ok
      else
        raise 'Autenticación incorrecta.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # @email definitive username for both systems
  # @password definitive password for both systems
  def synchronize_accounts
    begin
      remote_valid_email = User.remote_validate_email(params[:email]), session[:request_headers]
      valid_email = current_user.validate_email(params[:email])
      
      if valid_email and remote_valid_email.code == "200"
        
        # synchronize user, password
        remote_valid_update = User.remote_update_account(params[:email], params[:password], session[:request_headers])
        valid_update = current_user.update_account(params[:email], params[:password]) 
        
        if valid_update and remote_valid_update.code == "200"
          render json: current_user, status: :ok
        else
          raise 'La sincronización de usuario y contraseña no pudo realizarse. Favor de ponerse en contacto con el administrador.' 
        end
      else
        raise 'El correo seleccionado tiene a un usuario que no está vinculado a esta cuenta. Favor de ponerse en contacto con el administrador.'
      end

    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # CALLED FROM SYSTEM TO SYSTEM  

  # @email
  def validate_email
    begin
      valid_email = current_user.validate_email params[:email]
      if valid_email 
        render json: current_user, status: :ok
      else
        raise 'El correo seleccionado tiene a un usuario que no está vinculado a esta cuenta. Favor de ponerse en contacto con el administrador.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end
  
  def remote_login
    begin
      response = current_user.remote_login 
      if response.code == "200"
        session[:request_headers] = Connection.get_headers response
        render json: current_user, status: :ok
      else
        raise 'Autenticación incorrecta.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # @email
  # @password
  def update_account
    begin
      valid_update = current_user.update_account params[:email], params[:password]
      if valid_update
        render json: current_user, status: :ok
      else
        raise 'Error actualizando la cuenta.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # N-bici unique methods

  # @classes_left
  # @expiration_date
  def receive_classes_left
    begin 
      valid_migration = current_user.migrate_classes_left params[:classes_left], params[:expiration_date]
      if valid_migration
        render json: current_user, status: :ok
      else
        raise 'Error migrando las clases disponibles hacia N-bici. Favor de ponerse en contacto con el administrador.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  def migrate_accounts
    begin
      # request classes_left
      response = User.remote_request_classes_left(session[:request_headers])
      if response.code == "200"
        classes_left_info = JSON.parse(response.body)
        
        # saving data for rollback if needed
        old_classes_left = current_user.classes_left
        old_expiration_date = current_user.expiration_date

        valid_migration = current_user.migrate_classes_left classes_left_info["user"]["classes_left"], classes_left_info["user"]["expiration_date"]
        if valid_migration
          render json: current_user, status: :ok
        else
          current_user.update_attributes!(classes_left: old_classes_left, expiration_date: old_expiration_date, linked: false)
          raise 'Error migrando las clases disponibles hacia N-bici. Favor de ponerse en contacto con el administrador.'
        end        
      else
        raise 'Error obteniendo las clases disponibles desde N-box. Favor de ponerse en contacto con el administrador.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :classes_left, :last_class_purchased, :picture, :uid, :active, :password, :password_confirmation)
    end
end
