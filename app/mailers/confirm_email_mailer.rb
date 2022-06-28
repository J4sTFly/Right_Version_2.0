# frozen_string_literal: true

class ConfirmEmailMailer < ApplicationMailer
  def send_confirmation(user)
    @token = user.confirmation_token
    mail(from: ENV['MAIL_FROM'], to: user.email, subject: 'Confirm email')
  end
end
