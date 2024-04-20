class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user

  def show; end

  private

  def authorize_user
    return if params[:id].to_i == current_user.id

    render file: 'public/401.html', status: :unauthorized
  end
end
