# frozen_string_literal: true

module Model
  # Класс для вызова ошибки одной валидации
  # @param msg [String] сообщение, которое будет отдаваться
  # @param http [Integer] http-код ошибки
  # @param pointer [Hash] source[:pointer] ошибки
  class SingleValidationError < BaseError
    def initialize(msg = '', http = 422, pointer: nil)
      super
    end
  end
end
