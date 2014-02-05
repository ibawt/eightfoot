class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    @user = User.find_for_github_auth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event =>:authentication
      set_flash_message(:notice, :success, :kind => 'Github')
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
