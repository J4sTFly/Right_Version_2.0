# frozen_string_literal: true

module V1
  class UsersControllerPolicy < ApplicationPolicy
    def index?
      user.present? || raise(ForbiddenError)
    end

    def create?
      (!user.present? || admin?) || raise(AuthorizedError)
    end

    def update?
      user.present? || raise(ForbiddenError)
    end
  end
end
