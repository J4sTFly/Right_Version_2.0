# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::AccountsController, type: :controller do
  describe 'POST v1/account/login' do
    let(:user) { create :user }
    let(:default_request) do
      post :login, params: params, format: :json
    end

    context 'когда юзер залогинен' do
      let(:params) do
        {
          user: {
            username: 'user'
          }
        }
      end

      let(:http_code) { 403 }
      let(:title) { I18n.t('errors.messages.authorized_error') }
      let(:error_detail) { I18n.t('errors.messages.authorized_detail') }
      let(:code) { 403 }

      let(:user) { create :user }

      let(:request_headers) do
        { 'Authorization': jwt_encode(user_id: user.id), 'Content-Type': 'application/json' }
      end

      before do
        request.headers.merge!(request_headers)
        request.params.merge!(params)
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда email нет в базе' do
      let(:params) do
        {
          user: {
            email: 'nnnntntnt@gmail.com'
          }
        }
      end
      let(:http_code) { 404 }
      let(:code) { 404 }
      let(:title) { I18n.t('errors.messages.active_record.not_found_error') }
      let(:error_detail) { I18n.t('errors.messages.active_record.not_found') }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда пароль неверный' do
      let(:params) do
        {
          user: {
            email: user.email,
            password: 'wrongpass'
          }
        }
      end
      let(:http_code) { 400 }
      let(:code) { 400 }
      let(:title) { I18n.t('errors.messages.bad_credentials_error') }
      let(:error_detail) { I18n.t('errors.messages.auth.bad_credentials') }

      before do
        user.confirm
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда пароль верный' do
      let(:params) do
        {
          user: {
            email: user.email,
            password: 'password1234'
          }
        }
      end

      before do
        user.confirm
        default_request
      end

      it 'отдает JWT токен' do
        expect(response.headers).to include('Authorization')
      end
    end
  end
end
