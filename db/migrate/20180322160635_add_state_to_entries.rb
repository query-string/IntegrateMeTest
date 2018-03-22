class AddStateToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :state, :string, default: 'pending', null: false
  end
end
