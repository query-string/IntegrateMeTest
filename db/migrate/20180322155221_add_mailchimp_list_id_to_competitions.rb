class AddMailchimpListIdToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :mailchimp_list_id, :string
  end
end
