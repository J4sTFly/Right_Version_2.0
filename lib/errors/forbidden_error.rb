# frozen_string_literal: true

class ForbiddenError < BaseError
  def initialize(msg = I18n.t('errors.messages.forbidden_detail'), http = 403)
    super
  end
end
