# frozen_string_literal: true

class BadRequest < BaseError
  def initialize(msg = I18n.t('errors.messages.bad_request'), http = 401)
    super
  end
end
