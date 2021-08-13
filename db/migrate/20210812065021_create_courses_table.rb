class CreateCoursesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.boolean :activated, default: false
      t.datetime :start_time
      t.datetime :finish_time
      t.text :description

      t.timestamps
    end
  end
end
