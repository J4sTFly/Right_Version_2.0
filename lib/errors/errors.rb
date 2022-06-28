# frozen_string_literal: true

module Errors
  CODES = {
    BaseError: 0,
    'Auth::AuthorizationError': 1,
    InvalidParamsError: 4,
    ForbiddenError: 5,
    TokenExpiredError: 6,
    'Emails::SMTPError': 100,

    BadRequestError: 400,
    BadCredentialsError: 400,
    FilterNotAllowedError: 400,
    UnauthorizedError: 401,
    AuthorizedError: 403,
    NotFoundError: 404,
    'Model::SingleValidationError': 422,
    ServiceUnavailableError: 503

  }.freeze
end
