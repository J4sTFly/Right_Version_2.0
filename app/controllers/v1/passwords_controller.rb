# frozen_string_literal: true

class V1::PasswordsController < ApplicationController
  # POST /v1/passwords/restore
  def restore_password
    @user = User.confirmed.find_by_email restore_params[:email]
    raise ActiveRecord::RecordNotFound unless @user

    @user.update(reset_password_token: SecureRandom.uuid,
                 reset_token_expires: Time.current.advance(hours: 3))
    RestorePasswordMailer.send_token(@user).deliver_now
  end

  def update_password
    @user = User.confirmed.find_by reset_password_token: params[:reset_password_token]
    raise ActiveRecord::RecordNotFound unless @user
    raise TokenExpiredError if @user.reset_token_expires < Time.now

    @user.reset_password(restore_params)
    @user
  end

  def restore_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
