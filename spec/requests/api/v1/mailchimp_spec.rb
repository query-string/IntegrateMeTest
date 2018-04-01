require 'rails_helper'

describe Api::V1::MailchimpController, type: :request do
  describe '#proxy' do
    subject    { get '/api/v1/mailchimp/proxy', api_key: api_key }
    before     { subject }
    let(:body) { JSON.parse(response.body) }

    context 'when MailChimp API key is not valid' do
      let(:api_key) { nil }

      it 'returns error header' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when MailChimp API key is valid' do
      let(:api_key) { ENV['MAILCHIMP_KEY'] }

      it 'returns ok header' do
        expect(response).to have_http_status(:ok)
      end
      it 'JSON has subscription lists' do
        expect(body.keys.include?('lists')).to be_truthy
      end
      it 'subscription lists have expected values' do
        list = body['lists'].last
        expect(list['id']).to eq '96dcf3ccd1'
        expect(list['name']).to eq 'FunMode'
      end
    end
  end
end