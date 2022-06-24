# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PasswordsController, type: :controller do
  describe 'POST v1/passwords/reset' do
    let(:default_request) do
      post :update_password, params: params, format: :json
    end

    let(:user) { create :user }

    let(:set_token) do
      user.confirm
      user.update(reset_password_token: SecureRandom.uuid,
                  reset_token_expires: DateTime.current.advance(hours: 3))
    end

    context 'когда юзер по токену не найден' do
      let(:params) do
        {
          reset_password_token: 'random'
        }
      end

      let(:title) { I18n.t('errors.messages.not_found_error') }
      let(:error_detail) { I18n.t('errors.messages.active_record.not_found') }
      let(:http_code) { 404 }
      let(:code) { 404 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда токен истек' do
      let(:params) do
        {
          reset_password_token: user.reset_password_token
        }
      end

      let(:http_code) { 400 }
      let(:title) { I18n.t('errors.messages.token_expired_error') }
      let(:error_detail) { I18n.t('errors.messages.passwords.token_expired_detail') }
      let(:code) { 6 }

      before do
        user.confirm
        user.update(reset_password_token: SecureRandom.uuid,
                    reset_token_expires: DateTime.current.advance(hours: -3))
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'when пароли не совпадают' do
      let(:params) do
        {
          reset_password_token: user.reset_password_token,
          user: {
            password: 'password1234',
            password_confirmation: 'passw'
          }
        }
      end

      let(:http_code) { 401 }
      let(:code) { 0 }
      let(:title) { I18n.t('errors.messages.bad_request') }
      let(:error_detail) { I18n.t('errors.messages.bad_request') }

      before do
        set_token
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'успешная смена пароля' do
      let(:params) do
        {
          reset_password_token: user.reset_password_token,
          user: {
            password: 'password1234',
            password_confirmation: 'password1234'
          }
        }
      end

      before do
        set_token
        default_request
      end

      it 'отвечает с кодом 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
