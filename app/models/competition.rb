class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition
  validates_presence_of :name

  def get_list(attribute = :id)
    get_lists.select { |l| l['name'] == name }.first[attribute.to_s]
  end

  private

  def get_lists
    Gibbon::Request.lists.retrieve.body['lists']
  end
end
