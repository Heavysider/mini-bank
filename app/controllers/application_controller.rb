class ApplicationController < ActionController::Base
  def after_sign_in_path_for(_resource_name)
    user_path(current_user)
  end
end
