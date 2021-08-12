class CreateReportsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.datetime :date
      t.text :description

      t.timestamps
    end
  end
end
