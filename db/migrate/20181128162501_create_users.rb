class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username,           null: false
      t.string :email,              null: false, default: ""
      t.string :first_name,         null: false
      t.string :last_name,          null: false
      t.string :password_digest, null: false, default: ""
      t.string :type,               null: false

      t.timestamps null: false
    end
  end
end
