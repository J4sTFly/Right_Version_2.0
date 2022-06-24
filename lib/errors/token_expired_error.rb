# frozen_string_literal: true

class TokenExpiredError < BaseError
  def initialize(msg = I18n.t('errors.messages.passwords.token_expired_detail'), http = 400)
    super
  end
end
