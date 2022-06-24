# frozen_string_literal: true

module V1
  class ConfirmationsControllerPolicy < ApplicationPolicy
    def confirm_email?
      !user.present? || raise(AuthorizedError)
    end
  end
end
