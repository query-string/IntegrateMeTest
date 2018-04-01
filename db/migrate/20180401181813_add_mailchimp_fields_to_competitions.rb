class AddMailchimpFieldsToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :mailchimp_api_key, :string
  end
end
