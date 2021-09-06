class AddEstimatedEndTimeToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :estimated_end_time, :datetime
  end
end
