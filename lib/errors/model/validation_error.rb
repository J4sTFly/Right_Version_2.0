# frozen_string_literal: true

module Model
  # Класс для вызова ошибки валидации
  # @param errors [ActiveModel::Errors] ошибка валидации
  # @param http [Integer] http-код ошибки
  class ValidationError < MultiError
    def initialize(errors, http = 422)
      errors = errors.to_hash(:full_messages) if errors.is_a? ActiveModel::Errors
      super(hsh_error(errors, nil), http)
    end

    private

    def hsh_error(obj, top_level_attr) # rubocop:disable Metrics/MethodLength
      if obj.is_a? Array
        return obj.map do |elem|
          if elem.is_a? BaseError
            elem
          else
            SingleValidationError.new(elem, 422, pointer: "/data/attributes#{top_level_attr}")
          end
        end
      end

      obj = build_errors_tree(obj)

      obj.map do |attr, value|
        hsh_error(value, "#{top_level_attr}/#{attr}")
      end.inject(&:+)
    end

    def build_errors_tree(obj)
      obj.reduce({}) do |hash, error|
        errors_tree = error[0].to_s.split('.').reverse_each.reduce({}) do |v, k|
          { k.to_sym => v.empty? ? error[1] : v }
        end
        hash.deep_merge!(errors_tree)
      end
    end
  end
end
