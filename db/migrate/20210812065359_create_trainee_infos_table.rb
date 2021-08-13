class CreateTraineeInfosTable < ActiveRecord::Migration[6.0]
  def change
    create_table :trainee_infos do |t|
      t.belongs_to :user, index: {unique: true}, foreign_key: true
      t.integer :garaduate_year
      t.string :university
      t.datetime :start_training_time
      t.datetime :finish_training_time
    end
  end
end
