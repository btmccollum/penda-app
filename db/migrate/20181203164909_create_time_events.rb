class CreateTimeEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :time_events do |t|
      t.integer :project_id
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :finished

      t.timestamps
    end
  end
end
