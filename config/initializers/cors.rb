# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
cors_origins = ENV['ALLOWED_ORIGINS']&.split(',') || []

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins cors_origins

    resource '*',
             headers: :any,
             methods: :any,
             credentials: true
  end
end
