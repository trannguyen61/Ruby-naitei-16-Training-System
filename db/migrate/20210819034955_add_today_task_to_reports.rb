class AddTodayTaskToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :today_task, :text
  end
end
