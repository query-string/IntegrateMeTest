class AddMailchimpErrorLogToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :mailchimp_error_log, :jsonb, null: false, default: '{}'
    add_index :entries, :mailchimp_error_log, using: :gin
  end
end
