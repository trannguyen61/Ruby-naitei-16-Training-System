class CreateStatusesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :statuses do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :finishable, polymorphic: true
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :statuses, %i(finishable_id finishable_type user_id), unique: true
  end
end
