class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition
  validates_presence_of :name

  def list_id
    update_column(:mailchimp_list_id, get_list(:id)) unless mailchimp_list_id.present?
    mailchimp_list_id
  end

  def get_list(attribute = :id)
    lists = get_lists.select { |l| l['name'] == name }
    raise NameError, "A list named `#{name}` doesn't exist on MailChimp side yet" unless lists.any?
    lists.first[attribute.to_s]
  end

  private

  def get_lists
    raise ArgumentError, 'MailChimp API key is not defined' unless mailchimp_api_key.present?
    Gibbon::Request.new(api_key: mailchimp_api_key).lists.retrieve.body['lists']
  end
end
