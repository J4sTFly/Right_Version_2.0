class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_secure_password(validations: false)
  devise :authenticatable

  has_one_attached :avatar

  validates_presence_of :password_confirmation, if: :password_required?

  validates :username,
            uniqueness: true,
            presence: true,
            length: { maximum: 50 }

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
            length: { maximum: 21 }
end
