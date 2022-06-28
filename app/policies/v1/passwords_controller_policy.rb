# frozen_string_literal: true

module V1
  class PasswordsControllerPolicy < ApplicationPolicy
    def restore_password?
      (!@current_user.present? || admin?) || raise(ForbiddenError)
    end

    def update_password?
      (!@current_user.present? || admin?) || raise(ForbiddenError)
    end
  end
end
