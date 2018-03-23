require 'rails_helper'

RSpec.describe MailChimp::SubscribeEntryJob, type: :job do
  fixtures :entries
  fixtures :competitions

  before  { ActiveJob::Base.queue_adapter = :test }
  subject { MailChimp::SubscribeEntryJob.perform_now entry }

  context 'when competition is not associated with the entry' do
    let(:entry) { entries(:entry_nameless) }

    it 'will stop execution' do
      expect { subject }.to raise_error(ArgumentError, 'No competitions associated to the entry')
    end
  end

  context 'when entry was added already' do
    let(:entry) { entries(:entry_fullname) }

    it 'updates entry state' do
      expect { subject }.to change { entry.state }.from('pending').to('failed')
    end
    it 'updates error log' do
      expect { subject }.to change { entry.mailchimp_error_log }
      expect(JSON.parse(entry.mailchimp_error_log)['title']).to eq 'Member Exists'
    end
  end

  context 'when entry is the first time subscriber' do
    let(:first_name)  { Faker::Name.unique.first_name }
    let(:last_name)   { Faker::Name.unique.last_name }
    let(:name)        { "#{first_name} #{last_name}" }
    let(:email)       { Faker::Internet.unique.email }
    let(:entry)       { Entry.create(name: name, email: email, competition_id: competition.id) }
    let(:competition) { competitions(:competition) }
    let(:members)     { Gibbon::Request.lists(competition.list_id).members.retrieve(params: { status: 'subscribed' }).body['members'] }

    after do
      Gibbon::Request.lists(competition.list_id)
        .members(Digest::MD5.hexdigest(email))
        .update(body: { status: 'unsubscribed' })
    end

    it 'updates entry state' do
      expect { subject }.to change { entry.state }.from('pending').to('completed')
    end
    it 'does not change error log' do
      expect { subject }.not_to change { entry.mailchimp_error_log }
    end
    it 'mailing list includes entry details' do
      subject
      expect(members.map { |m| m['email_address'] }.include?(email)).to be_truthy
    end
  end
end
