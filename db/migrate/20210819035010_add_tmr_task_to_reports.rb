class AddTmrTaskToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :tmr_task, :text
  end
end
