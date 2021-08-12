class CreateSubjectsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.belongs_to :course, index: true, foreign_key: true
      t.string :name
      t.datetime :start_time
      t.integer :length
      t.text :description

      t.timestamps
    end
  end
end
