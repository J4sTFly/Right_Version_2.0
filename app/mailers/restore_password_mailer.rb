# frozen_string_literal: true

class RestorePasswordMailer < ApplicationMailer
  def send_token(user)
    @token = user.reset_password_token
    mail(from: ENV['MAIL_FROM'], to: user.email, subject: 'Restore password')
  end
end
