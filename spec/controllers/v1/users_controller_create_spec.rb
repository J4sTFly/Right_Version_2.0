# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'POST v1/users' do
    let(:params) { {} }
    let(:default_request) do
      post :create, params: params, format: :json
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

    context 'когда запрос не содержит параметров' do
      let(:title) { I18n.t('errors.messages.bad_request') }
      let(:error_detail) { 'param is missing or the value is empty: user' }
      let(:http_code) { 401 }
      let(:code) { 0 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда email невалидный' do
      let(:params) do
        {
          user: {
            username: 'username',
            email: 'wrong',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      let(:title) { I18n.t('errors.messages.model/single_validation_error') }
      let(:error_detail) { 'Email is invalid' }
      let(:http_code) { 422 }
      let(:code) { 422 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда username невалидный' do
      let(:params) do
        {
          user: {
            username: '..',
            email: 'right@mail.ru',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      let(:title) { I18n.t('errors.messages.model/single_validation_error') }
      let(:error_detail) { 'Username is too short (minimum is 3 characters)' }
      let(:http_code) { 422 }
      let(:code) { 422 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда пароль невалидный' do
      let(:params) do
        {
          user: {
            username: 'username',
            email: 'right@mail.ru',
            password: 'pas',
            password_confirmation: 'pas'
          }
        }
      end

      let(:title) { I18n.t('errors.messages.model/single_validation_error') }
      let(:error_detail) { 'Password is too short (minimum is 8 characters)' }
      let(:http_code) { 422 }
      let(:code) { 422 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда пароли не совпадают' do
      let(:params) do
        {
          user: {
            username: 'user',
            email: 'right@mail.ru',
            password: 'password',
            password_confirmation: 'passwo'
          }
        }
      end

      let(:title) { I18n.t('errors.messages.model/single_validation_error') }
      let(:error_detail) { 'Password confirmation doesn\'t match Password' }
      let(:http_code) { 422 }
      let(:code) { 422 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда password_confirmation отсутствует' do
      let(:params) do
        {
          user: {
            username: 'user',
            email: 'right@gmail.com',
            password: 'password'
          }
        }
      end
      let(:request_headers) do
        { 'Content-Type': 'application/json' }
      end
      let(:title) { I18n.t('errors.messages.model/single_validation_error') }
      let(:error_detail) { 'Password confirmation can\'t be blank' }
      let(:http_code) { 422 }
      let(:code) { 422 }

      before do
        request.headers.merge!(request_headers)
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда указана невалидная роль' do
      let(:params) do
        {
          user: {
            username: 'user',
            email: 'right@gmail.com',
            password: 'password',
            password_confirmation: 'password',
            role: 2
          }
        }
      end
      let(:request_headers) do
        { 'Content-Type': 'application/json' }
      end
      let(:title) { I18n.t('errors.messages.forbidden_error') }
      let(:error_detail) { I18n.t('errors.messages.forbidden_detail') }
      let(:http_code) { 403 }
      let(:code) { 5 }

      before do
        request.headers.merge!(request_headers)
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    # fix
    context 'успешное создание' do
      let(:params) do
        {
          user: {
            username: 'user',
            email: 'right@gmail.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      let(:request_headers) do
        { 'Content-Type': 'application/json' }
      end
      let(:username) { 'user' }
      let(:email) { 'right@gmail.com' }
      let(:role) { 'user' }

      before do
        request.headers.merge!(request_headers)
        request.params.merge!(params)
        default_request
      end

      it 'возвращает модель юзера' do
        # expect(JSON.parse(response.body)["user"]).to include(username: username)
        # expect(JSON.parse(response.body)["user"]).to include(email: email)
        # expect(JSON.parse(response.body)["user"]).to include(role: role)
      end
    end
  end
end
