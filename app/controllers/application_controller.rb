# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Pundit::Authorization
  include JsonWebToken

  before_action :set_current_user
  before_action :authorize_action!
  after_action :verify_authorized

  rescue_from BaseError, MultiError, with: :render_errors

  rescue_from ActiveModel::ValidationError do |exception|
    render_errors(Model::ValidationError.new(exception.model.errors, 422))
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render_errors(BadRequest.new(exception))
  end

  rescue_from ActiveRecord::RecordInvalid do |invalid|
    render_errors(Model::ValidationError.new(invalid.record.errors))
  end

  rescue_from Pundit::NotAuthorizedError do
    render_errors(ForbiddenError.new)
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_errors(NotFoundError.new)
  end

  def pundit_user
    header = request.headers['Authorization']
    return nil unless header

    header = header.split(' ').last

    decoded = jwt_decode(header)
    User.find decoded[:user_id]
  end

  def authorize_action!
    authorize self
  end

  def set_current_user
    Current.user = @current_user
  end

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = jwt_decode(header)
    raise TokenExpiredError if RevokedJwt.find_by_value header

    @current_user = User.find decoded[:user_id]
  end

  def render_errors(exception)
    render(
      json: { errors: [exception.jsonapi_hash].flatten },
      status: exception.http
    )
  end
end
