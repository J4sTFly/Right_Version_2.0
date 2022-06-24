# frozen_string_literal: true

RSpec.describe V1::PasswordsController, type: :controller do
  let(:default_request) do
    post :restore_password, params: params, format: :json
  end

  describe 'POST v1/passwords/restore' do
    context 'когда запрос не содержит параметров' do
      let(:params) { {} }
      let(:title) { I18n.t('errors.messages.bad_request') }
      let(:error_detail) { 'param is missing or the value is empty: user' }
      let(:http_code) { 401 }
      let(:code) { 0 }

      before do
        default_request
      end

      it_behaves_like 'отдает jsonapi ошибку'
    end

    context 'когда юзер не найден' do
      let(:params) do
        {
          user: {
            email: 'not@found.com'
          }
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

    # fix
    context 'все ок' do
      let(:user) { create :user }
      let(:params) do
        {
          user: {
            email: user.email
          }
        }
      end

      before do
        user.confirm
        default_request
      end

      it 'возвращает код 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
