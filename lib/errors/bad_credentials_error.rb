# frozen_string_literal: true

class BadCredentialsError < BaseError
  def initialize(msg = I18n.t('errors.messages.auth.bad_credentials'), http = 400)
    super
  end
end
