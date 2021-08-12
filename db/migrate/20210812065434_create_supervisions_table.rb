class CreateSupervisionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :supervisions do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :course, index: true, foreign_key: true

      t.timestamps
    end

    add_index :supervisions, [:user_id, :course_id], unique: true
  end
end
