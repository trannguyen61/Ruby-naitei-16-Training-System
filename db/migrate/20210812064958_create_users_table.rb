class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.datetime :date_of_birth
      t.string :address
      t.integer :gender, default: 2
      t.integer :role, default: 0
      t.string :password_digest
      t.string :remember_digest
      t.boolean :activated, default: false
      t.string :activation_digest
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
