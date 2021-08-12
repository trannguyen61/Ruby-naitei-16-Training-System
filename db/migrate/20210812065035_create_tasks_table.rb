class CreateTasksTable < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :subject, index: true, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
