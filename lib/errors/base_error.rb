# frozen_string_literal: true

class BaseError < StandardError
  include Errors

  attr_reader :http, :pointer, :meta

  def initialize(msg = '', http = 500, pointer: nil, meta: nil)
    @http = http
    @pointer = pointer
    @meta = meta
    super(msg)
  end

  def code
    CODES[self.class.name.to_sym].to_i
  end

  def jsonapi_hash
    hash = {
      title: I18n.t("errors.messages.#{self.class.name.underscore}"),
      detail: message,
      code: code
    }

    hash[:source] = { pointer: pointer } if pointer.present?
    hash[:meta] = meta if meta.present?

    hash
  end
end
