# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'GET v1/users' do
    context 'если юзер не админ' do
      let(:default_request) do
        get 'index'
      end

      before do
        default_request
      end

      it 'отвечает с кодом 403' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'если юзер админ' do
      let(:admin) do
        create(:user, :admin)
      end

      let(:request_headers) do
        { 'Authorization': jwt_encode(user_id: admin.id), 'Content-Type': 'application/json' }
      end

      let(:default_request) do
        get :index
      end

      before do
        request.env['HTTP_ACCEPT'] = 'application/json'
        request.headers.merge!(request_headers)

        default_request
      end

      it 'отвечает с кодом 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
