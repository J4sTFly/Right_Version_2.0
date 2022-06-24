# frozen_string_literal: true

class AuthorizedError < ForbiddenError
  def initialize(msg = I18n.t('errors.messages.authorized_detail'), http = 403)
    super
  end
end
