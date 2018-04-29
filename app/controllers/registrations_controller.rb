class RegistrationsController < Devise::RegistrationsController
  before_filter :redirect_existing_users, only: [:create]


  def redirect_existing_users
    if User.exists?(sign_up_params)
      flash[:notice] = "We're pretty sure that account already exists here... Did you forget your password?"
      redirect_to(new_session_path(:user, sign_up_params)) and return
    end
  end

  def after_sign_up_path_for(resource)
    get_started_path(email: resource.email)
  end

  def after_inactive_sign_up_path_for(resource)
    get_started_path(email: resource.email)
  end

  def user_update
    if current_user.update!(params.require(:user).permit(:public_name))
      flash[:notice] = "Good Job #{params.dig(:user, :public_name)}"
    end
    redirect_to(edit_registration_path(current_user))
  end
end
