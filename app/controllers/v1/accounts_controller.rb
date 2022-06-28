# frozen_string_literal: true

class V1::AccountsController < ApplicationController
  before_action :authenticate_request, except: %i[login]

  # POST v1/account/login
  def login
    @user = User.confirmed.find_by_email account_params[:email]
    raise ActiveRecord::RecordNotFound unless @user

    raise BadCredentialsError unless @user.authenticate(account_params[:password])

    token = jwt_encode(user_id: @user.id)
    response.headers['Authorization'] = token
    @user
  end

  # DELETE v1/account/logout
  def logout
    RevokedJwt.create!(value: request.headers['Authorization'])
    @user = @current_user
  end

  private

  def account_params
    params.require(:user).permit(:email, :password)
  end
end
