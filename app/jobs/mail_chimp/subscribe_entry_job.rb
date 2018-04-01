class MailChimp::SubscribeEntryJob < ActiveJob::Base
  queue_as :default

  def perform(entry)
    competition = entry.competition
    raise ArgumentError, 'No competitions associated to the entry' unless competition
    raise ArgumentError, 'MailChimp API key is not defined' unless competition.mailchimp_api_key.present?

    entry.update(state: :processing)

    begin
      request_entry entry, competition
      entry.update(state: :completed)
    rescue Gibbon::MailChimpError => e
      entry.update(state: :failed, mailchimp_error_log: e.raw_body)
    end
  end

  private

  def request_entry(entry, competition)
    request_body = {
      body: {
        email_address: entry.email,
        merge_fields:  { FNAME: entry.first_name, LNAME: entry.last_name },
        status:        :subscribed
      }
    }

    Gibbon::Request.new(api_key: competition.mailchimp_api_key)
      .lists(competition.list_id)
      .members
      .create(request_body)
  end
end
