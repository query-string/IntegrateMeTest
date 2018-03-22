class MailChimp::SubscribeEntryJob < ActiveJob::Base
  queue_as :default

  def perform(entry)
    competition = entry.competition
  end
end
