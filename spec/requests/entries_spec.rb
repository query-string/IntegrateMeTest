require 'rails_helper'

describe 'entries', type: :request do
  fixtures :entries
  fixtures :competitions

  let(:body) { JSON.parse(response.body) }

  describe '#create' do
    let(:competition)  { competitions(:competition) }
    let(:entry_params) { { competition_id: competition.id, name: 'Alexander', email: 'alexander@query-string.com' } }

    subject { post '/entries', entry: entry_params }
    before  { ActiveJob::Base.queue_adapter = :test }

    it 'enqueues the job' do
      expect { subject }.to have_enqueued_job(MailChimp::SubscribeEntryJob)
    end

    it 'returns entry details' do
      subject
      expect(body['entry'].keys).to eq %w[id state]
    end
  end

  describe '#show' do
    let(:entry) { entries(:entry_fullname) }
    before      { get "/entries/#{entry.id}" }

    it { expect(response).to be_success }

    it 'returns entry' do
      expect(body.keys.include?('entry')).to be_truthy
    end
    it 'returns entry details' do
      expect(body['entry'].keys).to eq %w[id state log]
    end
  end
end
