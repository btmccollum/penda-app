class CreateTimeEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :time_entries do |t|
      t.integer :project_id
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :finished, null: false, default: false

      t.timestamps
    end
  end
end
