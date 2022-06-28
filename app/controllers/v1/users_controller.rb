# frozen_string_literal: true

class V1::UsersController < ApplicationController
  before_action :authenticate_request, except: %i[index create]
  before_action :validate_params, only: %i[create update]

  # GET v1/users/
  def index
    @users = User.all
  end

  # POST v1/users/
  def create
    @user = User.create!(user_params)
    @user
  end

  # GET v1/users/:slug
  def show; end

  # POST v1/users/:slug
  def update
    @user = User.find_by_username user_params[:username]
    raise NotFoundError unless @user.present?

    @user.update(user_params)
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation,
                                 :bio, :country, :phone, :avatar, :role,
                                 :force_confirmation)
  end

  def validate_params
    raise ForbiddenError if user_params[:role].present? && user_params[:role] > 1
  end
end
