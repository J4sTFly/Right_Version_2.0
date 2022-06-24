# frozen_string_literal: true

module V1
  class AccountsControllerPolicy < ApplicationPolicy
    def login?
      !user.present? || raise(AuthorizedError)
    end

    def logout?
      user.present? || raise(UnauthorizedError)
    end
  end
end
