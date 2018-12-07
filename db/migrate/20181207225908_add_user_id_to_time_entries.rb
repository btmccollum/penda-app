class AddUserIdToTimeEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :time_entries, :user_id, :integer
  end
end
