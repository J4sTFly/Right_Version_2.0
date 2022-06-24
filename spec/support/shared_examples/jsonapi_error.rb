# frozen_string_literal: true

RSpec.shared_examples 'отдает jsonapi ошибку' do
  it 'и отвечает с определенным http-кодом' do
    expect(response).to have_http_status(http_code)
  end

  it 'и выдает название ошибки' do
    expect(JSON.parse(response.body)['errors'][0]).to include('title' => title)
  end

  it 'и выдает код ошибки' do
    expect(JSON.parse(response.body)['errors'][0]).to include('code' => code)
  end

  it 'и выдает детальное описание ошибки' do
    expect(JSON.parse(response.body)['errors'][0])
      .to include('detail' => error_detail)
  end
end
