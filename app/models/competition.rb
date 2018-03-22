class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition
  validates_presence_of :name

  def get_list(attribute = :id)
    get_lists.select { |l| l['name'] == name }.first[attribute.to_s]
  end

  def list_id
    update_column(:mailchimp_list_id, get_list(:id)) unless mailchimp_list_id.present?
    mailchimp_list_id
  end

  private

  def get_lists
    Gibbon::Request.lists.retrieve.body['lists']
  end
end
