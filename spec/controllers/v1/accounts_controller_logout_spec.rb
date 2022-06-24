# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::AccountsController, type: :controller do
  describe 'POST v1/account/logout' do
    let(:default_request) do
      post :logout, format: :json
    end

    let(:user) { create :user }

    context 'когда юзер не найден по токену' do
      let(:code) { 404 }
      let(:http_code) { 404 }
      let(:title) { I18n.t('errors.messages.not_found_error') }
      let(:error_detail) { I18n.t('errors.messages.active_record.not_found') }

      before do
        request.headers.merge!({ Authorization: jwt_encode(user_id: 0) })
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда юзер не залогинен' do
      let(:code) { 401 }
      let(:http_code) { 401 }
      let(:title) { I18n.t('errors.messages.unauthorized_error') }
      let(:error_detail) { I18n.t('errors.messages.unauthorized_detail') }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'успешно разлогинивается' do
      let(:user) { create :user }
      let(:request_headers) do
        { 'Authorization': jwt_encode(user_id: user.id), 'Content-Type': 'application/json' }
      end

      before do
        request.headers.merge!(request_headers)
        default_request
      end

      it 'закидывает токен в таблицу revoked' do
        expect(!RevokedJwt.find_by_value(request.headers['Authorization']).nil?).to eq(true)
      end
    end
  end
end
