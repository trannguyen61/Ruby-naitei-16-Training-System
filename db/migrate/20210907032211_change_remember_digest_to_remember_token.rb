class ChangeRememberDigestToRememberToken < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :remember_digest, :remember_token
  end
end
