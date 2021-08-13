class CreateEnrollmentsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :enrollments do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :course, index: true, foreign_key: true
      t.datetime :enroll_time
      t.datetime :finish_time

      t.timestamps
    end

    add_index :enrollments, [:user_id, :course_id], unique: true
  end
end
