class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.integer :business_id
      t.integer :client_id
      t.string :title
      
      t.timestamps
    end
  end
end
