class AddTitleToTimeEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :time_entries, :title, :string
  end
end
