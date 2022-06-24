# frozen_string_literal: true

class UnauthorizedError < ForbiddenError
  def initialize(msg = I18n.t('errors.messages.unauthorized_detail'), http = 401)
    super
  end
end
