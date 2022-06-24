# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ConfirmationsController, type: :controller do
  render_views
  describe 'get v1/email/confirm/:token' do
    let(:default_request) do
      get :confirm_email, params: params, format: :json
    end

    let(:user) { create :user }
    let(:request_headers) do
      { 'Authorization': jwt_encode(user_id: user.id), 'Content-Type': 'application/json' }
    end
    let(:params) { { token: 'token' } }

    context 'когда юзер залогинен' do
      let(:http_code) { 403 }
      let(:title) { I18n.t('errors.messages.authorized_error') }
      let(:error_detail) { I18n.t('errors.messages.authorized_detail') }
      let(:code) { 403 }

      before do
        request.headers.merge!(request_headers)
        request.params.merge!(params)
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда токен неверный' do
      let(:http_code) { 404 }
      let(:title) { I18n.t('errors.messages.not_found_error') }
      let(:error_detail) { I18n.t('errors.messages.active_record.not_found') }
      let(:code) { 404 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда токен истек' do
      let(:params) do
        {
          token: user.confirmation_token
        }
      end

      let(:http_code) { 400 }
      let(:title) { I18n.t('errors.messages.token_expired_error') }
      let(:error_detail) { I18n.t('errors.messages.passwords.token_expired_detail') }
      let(:code) { 6 }

      before do
        user.update(confirmation_token: SecureRandom.uuid,
                    token_expires_at: DateTime.current.advance(hours: -3))
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'токен верный' do
      let(:params) { { token: user.confirmation_token } }

      before do
        user.set_confirmation_token

        request.params.merge!(params)
        default_request
      end

      it 'возвращает юзера' do
        expect(JSON.parse(response.body)['user']).to include('username' => 'user_test',
                                                             'email' => 'test_mail@gmail.com',
                                                             'role' => 'user')
      end
    end
  end
end
