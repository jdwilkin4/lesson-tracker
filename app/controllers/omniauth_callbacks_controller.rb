class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_devise_mapping, only: [:google_oauth2, :failure]

  def google_oauth2
      Rails.logger.debug "Devise mappings: #{Devise.mappings.inspect}"

      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
  end

  def failure
      flash[:error] = 'There was an error while trying to authenticate you...'
      redirect_to new_user_session_path
  end

  private

  def set_devise_mapping
      @request.env["devise.mapping"] = Devise.mappings[:user] if @request
  end

end
