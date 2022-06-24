# frozen_string_literal: true

class NotFoundError < BaseError
  def initialize(msg = I18n.t('errors.messages.active_record.not_found'), http = 404)
    super
  end
end
