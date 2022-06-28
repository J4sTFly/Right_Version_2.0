# frozen_string_literal: true

class V1::ConfirmationsController < ApplicationController
  # GET v1/emails/confirm/:token
  def confirm_email
    @user = User.find_by confirmation_token: params[:token]
    raise ActiveRecord::RecordNotFound unless @user

    @user.confirm
  end
end
