class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|
      t.text :content
      t.integer :project_id
      t.boolean :completed, null: false, default: false
      t.boolean :business_signed, null: false, default: false
      t.boolean :client_signed, null: false, default: false

      t.timestamps
    end
  end
end
