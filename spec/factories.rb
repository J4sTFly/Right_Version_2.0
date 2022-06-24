# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'user_test' }
    email { 'test_mail@gmail.com' }
    password { 'password1234' }
    password_confirmation { 'password1234' }
    role { 'user' }

    trait :admin do
      username { 'admin_test' }
      email { 'admin_mail@gmail.com' }
      password { 'password1234' }
      password_confirmation { 'password1234' }
      role { 'admin' }
      force_confirmation { true }
    end
  end
end
