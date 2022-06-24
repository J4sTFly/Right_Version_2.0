# frozen_string_literal: true

# AuthorizedUserPolicy Проверяет наличие авторизованного пользователя
class AuthorizedUserPolicy < ApplicationPolicy
  def initialize(user, record)
    raise UnauthorizedError unless user

    super
  end
end
