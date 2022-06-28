# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_secure_password(validations: false)

  has_one_attached :avatar
  after_create :send_confirmation

  validates :password,
            presence: true,
            confirmation: true,
            length: { minimum: 8 },
            on: :create
  validates :password_confirmation, presence: true, on: :create

  validates :username,
            uniqueness: true,
            presence: true,
            length: { minimum: 3, maximum: 50 }

  validates :email,
            uniqueness: true,
            presence: true,
            length: { maximum: 255 },
            format: { with: Devise.email_regexp }

  enum role: {
    user: 0,
    writer: 1,
    admin: 2
  }

  validates :phone,
            numericality: true,
            length: { maximum: 21 }, if: :phone_change

  attribute :password
  attribute :password_confirmation
  attribute :force_confirmation

  scope :confirmed, -> { where('confirmed_at IS NOT NULL') }

  def send_confirmation
    return confirm if force_confirmation?

    set_confirmation_token

    ConfirmEmailMailer.send_confirmation(self).deliver_now
  end

  def set_confirmation_token
    update(confirmation_token: SecureRandom.uuid,
           token_expires_at: DateTime.current.advance(hours: 3))
  end

  def confirm
    return if force_confirmation?

    raise TokenExpiredError if token_expires_at < DateTime.current

    update(confirmed_at: DateTime.current)
  end

  def force_confirmation?
    force_confirmation
  end

  def reset_password(params)
    raise BadRequest if params[:password] != params[:password_confirmation] && !params[:password].nil?

    update(reset_password_token: nil,
           password: params[:password])
  end
end
