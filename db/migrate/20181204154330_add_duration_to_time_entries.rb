class AddDurationToTimeEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :time_entries, :duration, :decimal
  end
end
