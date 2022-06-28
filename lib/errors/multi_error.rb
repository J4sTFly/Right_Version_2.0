# frozen_string_literal: true

# Базовый класс мульти-ошибки
# @param errors [Array<BaseError>] массив ошибок BaseError
# @param http [Integer] http-код
class MultiError < StandardError
  attr_reader :errors, :http

  def initialize(errors = [], http = 500)
    @http = http
    @errors = errors

    super(@errors.map(&:message).join("\n"))
  end

  def jsonapi_hash
    @errors.map(&:jsonapi_hash)
  end
end
